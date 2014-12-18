# coding: utf-8
module Fir
  class Cli
    private
    def _chk_login!(prompt = true)
      if !_opt_token && prompt == true
        token = _prompt_secret('请输入用户 token：')
        @token = token if token.length > 0
      end
      if !@token
        _puts_require_token
        _exit
      elsif !_user(@token)
        _puts_invalid_token
        _exit
      end
    end
    def _chk_os!(os)
      if _os != os
        _puts "! #{Paint["该指令不支持在非 #{os} 系统执行", :red]}"
        _exit
      end
    end
    def _chk_opt!(*opts)
      opts.each do |_opt|
        if !_opt? _opt.to_sym
          _puts "! #{Paint["缺少参数 #{_opt}", :red]}"
          _exit
        end
      end
    end
  end
end
