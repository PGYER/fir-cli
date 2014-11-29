module Fir
  class Cli
    desc 'version', '当前版本'
    def version
      _puts "> FIR Cli #{VERSION}"
    end
  end
end
