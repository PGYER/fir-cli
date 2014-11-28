module Fir
  class Cli < Thor
    desc 'login', '登录'
    option :verbose, :aliases => '-v', :desc => '设置输出级别 v, vv, vvv'
    option :quite, :aliases => '-q', :desc => '安静模式，不输出任何选项'
    def login
      token = _prompt_secret('输入你的用户 token：')
      if token.empty?
        _puts_require_token
        exit 1
      end
      user = _user token
      if !user
        _puts_invalid_token
        exit 1
      end
      if _opt_token && _opt_token != token
        _puts "> 已登陆用户: #{_opt_token}"
        _puts "> 替换为用户: #{token}"
      end
      if user[:email]
        _puts "> 设置用户邮件地址为: #{user[:email]}"
        @config['email'] = user[:email]
      end
      @config['token'] = token
      @config.save
      _puts "> 当前登陆用户为：#{token}"
    end
  end
end
