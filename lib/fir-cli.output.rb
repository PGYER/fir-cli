# coding: utf-8
module Fir
  class Cli
    def self.output_options
      option :verbose,
             :desc => '设置输出辅助信息的详细程度',
             :type => :string,
             :enum => ['v', 'vv', 'vvv']
      option :quiet,
             :aliases => '-q',
             :desc => '安静模式，不输出任何辅助信息',
             :type => 'boolean'
      option :color,
             :desc => '设置输出带有颜色的信息',
             :type => 'boolean'
    end
    private
    def _puts(text)
      return puts _format text if !/^[->!] /.match text
      return if _opt_quiet
      case _opt_verbose || 'vv' # If nothing about log is set, use the default option - vv
      when 'v'
        puts _format text if text.start_with?('!')
      when 'vv'
        puts _format text if text.start_with?('!') || text.start_with?('>')
      when 'vvv'
        puts _format text if text.start_with?('!') || text.start_with?('>') || text.start_with?('-')
      end
    end
    def _format(text)
      return text.gsub /\e\[\d+(?:;\d+)*m/, '' if _opt_color == false
      text
    end
    def _puts_welcome
      _puts "> #{Paint['欢迎使用 FIR.im 命令行工具，如需帮助请输入:', :green]} fir help"
    end
    def _puts_require_token
      _puts "! #{Paint['用户 token 不能为空', :red]}"
    end
    def _puts_invalid_token
      _puts "! #{Paint['输入的用户 token 不合法', :red]}"
    end
    def _puts_invalid_email
      _puts "! #{Paint['输入的邮件地址不合法', :red]}"
    end
    def _prompt_secret(prompt)
      prompt = '' if _opt_quiet
      ask(prompt) { |_q| _q.echo = false }
    end
    def _prompt(prompt)
      prompt = '' if _opt_quiet
      ask(prompt) { |_q| _q }
    end
  end
end
