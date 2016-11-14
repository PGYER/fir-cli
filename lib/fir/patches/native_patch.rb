# encoding: utf-8

class File
  class << self
    # A binary file is Mach-O dSYM
    #
    # @return [true, false]
    def dsym?(file_path)
      !(`file -b #{file_path}` =~ /dSYM/).nil?
    end

    # A file is ASCII text
    #
    # @return [true, false]
    def text?(file_path)
      !(`file -b #{file_path}` =~ /text/).nil?
    end
  end
end

class String
  # Convert String encoding to UTF-8
  #
  # @return string
  def to_utf8
    encode(Encoding.find('UTF-8'), invalid: :replace, undef: :replace, replace: '')
  end
end
