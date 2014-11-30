module Fir
  class Cli
    desc 'upgrade', '更新 fir-cli 的所有组件'
    output_options
    def upgrade
      _puts '> gem update fir-cli'
      `gem update fir-cli`
      _extends.each do |gem|
        _puts "> gem update #{gem}"
        `gem update #{gem}`
      end
    end
  end
end
