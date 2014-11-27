require 'thor'

module Fir
  class Cli < Thor
    VERSION = "0.1.3"

    desc 'version', '当前版本'
    def version
      _puts "> FIR Cli #{VERSION}"
    end
  end
end
