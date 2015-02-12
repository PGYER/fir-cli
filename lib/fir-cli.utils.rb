# coding: utf-8
module Fir
  class Cli
    def initialize(*args)
      super
      @tmpfiles = []
      _init_config
      _load_config
      _puts_welcome
    end
    def self.find_extends
      `gem list --local`
        .each_line("\n")
        .map { |gem| /^[^\s]+/.match(gem)[0] }
        .select { |gem| true if gem.start_with? 'fir-cli-' }
    end
    private
    def _init_config
      @uconfig = UserConfig.new '.fir'
      @global_config = @uconfig['global.yaml']
    end
    def _load_config
      @config = @uconfig[_profile]
    end
    def _set_config(configs)
      if configs.length > 0
        configs.each do |option|
          _puts "> #{Paint[option[0].to_s.rjust(10), :blue]} : #{@config[option[0].to_s]} => #{option[1]}"
          @config[option[0].to_s] = option[1]
        end
        if @config['token'] && !_user(@config['token'])
          _puts_invalid_token
          _exit
        end
        @config.save
      end
    end
    def _profile
      @global_config['profile'] || 'default.yaml'
    end
    def _path(path)
      path = Pathname.new(Dir.pwd).join(path).cleanpath
    end
    def _is_ipa?(path)
      path.end_with? '.ipa'
    end
    def _is_apk?(path)
      path.end_with? '.apk'
    end
    def _is_workspace?(path)
      path.end_with? '.xcworkspace'
    end
    def _is_xcodeproject?(path)
      path.end_with? '.xcodeproj'
    end
    def _is_identifier?(str)
      /^(?:(?:[a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*(?:[A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$/.match str
    end
    def _is_email?(str)
      /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$/i.match str
    end
    def _extends
      @extends ||= Cli.find_extends
    end
    def _os
      return 'mac' if /darwin/ =~ RUBY_PLATFORM
      return 'windows' if /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM
      return 'linux'
    end
    def _exit
      exit 1
    end
    def _exec(cmd)
      output = `#{cmd}`
      if $?.exitstatus != 0
        puts output
        _exit
      end
    end
    def _convert_settings(*settings)
      settings.reduce({}) do |hash, setting|
        key,val = setting.split('=', 2).map(&:strip)
        hash[key.to_sym] = val
        hash
      end
    end
    def _edit(ipath, opath=nil)
      ipath = _path ipath
      if !opath then opath = ipath else opath = _path opath end
      extname = File.extname opath
      Dir.mktmpdir do |_d|
        Dir.chdir(_d) do

          Zip::ZipFile.open(ipath) do |_z|
            _z.each do |_entry|
              entrypath = File.join _d, _entry.name
              FileUtils.mkdir_p File.dirname entrypath
              _z.extract _entry, entrypath unless File.file? entrypath
            end
          end
          yield _d if block_given?
          File.unlink opath if File.file? opath
          _exec "zip -qr #{opath} Payload"
        end
      end
    end
  end
end
