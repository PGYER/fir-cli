module Fir
  class Cli < Thor
    desc 'upgrade all fir-cli toolbelts', '更新 fir-cli 的所有组件'
    option :verbose, :aliases => '-v', :desc => '设置输出级别 v, vv, vvv'
    option :quiet, :aliases => '-q', :desc => '安静模式，不输出任何选项'
    def upgrade
      _puts '> gem update fir-cli'
      `gem update fir-cli`
      _extends.each do |gem|
        _puts "> gem update #{ gem }"
        `gem update #{ gem }`
      end
    end
  end
end
