# frozen_string_literal: true
# require 'byebug'

require 'open3'
module FIR
  module Parser
    class AabAnalysis
      attr_accessor :aab_file, :head_xml, :bundletool_jar_path, :auto_download_bundletool_jar
      def initialize(aab_file, bundletool_jar_path = nil, auto_download_bundletool_jar = false)
        @aab_file = aab_file
        @bundletool_jar_path = bundletool_jar_path
        @auto_download_bundletool_jar = auto_download_bundletool_jar
      end

      def info
        insure_exists_bundlebool # 确保bundlebool 正常
        fetch_first_xml # 读取生成的第一句
        read_from_xml # 读取有用的的信息
      end

      def read_from_xml
        # 不到迫不得已 不要引用Nokogiri, 免得又装不来依赖
        {
          type: 'android',
          name: "AAB #{File.basename(@aab_file)}",
          identifier: read_from_attribute('package'),
          build: read_from_attribute('versionCode'),
          version: read_from_attribute('versionName')
        }
      end

      private

      def fetch_first_xml
        cmd = if bundletool_jar_path
          "java -jar #{bundletool_jar_path} dump manifest --bundle=#{aab_file}"
        else
          "bundletool dump manifest --bundle=#{aab_file}"
        end
        
        _stdin, stdout, _stderr, _wait_thr = Open3.popen3(cmd)
        @head_xml = stdout.read.split("\n").first
        FIR.logger.info "aab manifest: #{@head_xml}"
      end

      def insure_exists_bundlebool
        # 如果用户传了 bundletool_path, 且存在
        if !bundletool_jar_path.nil? && File.exist?(bundletool_jar_path)
          FIR.logger.info "bundletool_jar_path = #{bundletool_jar_path}"
          return
        end
        
        return if could_run_bundletool_directly?

        download_bundletool if auto_download_bundletool_jar
      end

      def could_run_bundletool_directly?
        _stdin, stdout, _stderr, _wait_thr = Open3.popen3 'bundletool'
        answer = stdout.read != ''
        FIR.logger.info "can invoke bundletool directly cool!" if answer
        answer
      rescue StandardError => e
        FIR.logger.error 'can not run bundletool directly'
        false
      end

      def download_bundletool(version = '0.11.0')
        FIR.logger.log("Downloading bundletool (#{version}) from https://github.com/google/bundletool/releases/download/#{version}/bundletool-all-#{version}.jar...")
        Dir.mkdir './bundletool_temp'
        open("https://github.com/google/bundletool/releases/download/#{version}/bundletool-all-#{version}.jar") do |bundletool|
          File.open('./bundletool.jar', 'wb') do |file|
            file.write(bundletool.read)
          end
        end
        @bundletool_jar_path = './bundletool.jar'
        FIR.logger.info('Downloaded bundletool')
      rescue StandardError => e
        FIR.logger.error("Something went wrong when downloading bundletool version #{version}")
      end

      def read_from_attribute(name)
        /#{name}=\"(.*?)\"/.match(@head_xml)[1]
      end
    end
  end
end
