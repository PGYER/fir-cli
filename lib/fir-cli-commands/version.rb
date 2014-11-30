module Fir
  class Cli
    desc 'version', '当前版本'
    output_options
    def version
      _puts "FIR Cli #{VERSION}"
    end
  end
end
