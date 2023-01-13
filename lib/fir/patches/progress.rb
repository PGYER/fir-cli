require 'net/http'
require 'tempfile'
require 'securerandom'

class Net::HTTP::UploadProgress
  attr_reader :upload_size

  def initialize(req, &block)
    @req = req
    @callback = block
    @upload_size = 0
    if req.body_stream
      @io = req.body_stream
      req.body_stream = self
    elsif req.instance_variable_get(:@body_data)
      raise NotImplementedError if req.chunked?
      raise NotImplementedError if /\Amultipart\/form-data\z/i !~ req.content_type
      opt = req.instance_variable_get(:@form_option).dup
      opt[:boundary] ||= SecureRandom.urlsafe_base64(40)
      req.set_content_type(req.content_type, boundary: opt[:boundary])
      file = Tempfile.new('multipart')
      file.binmode
      req.send(:encode_multipart_form_data, file, req.instance_variable_get(:@body_data), opt)
      file.rewind
      req.content_length = file.size
      @io = file
      req.body_stream = self
    else
      raise NotImplementedError
    end
  end

  def readpartial(maxlen, outbuf)
    begin
      str = @io.readpartial(maxlen, outbuf)
    ensure
      @callback.call(self) unless @upload_size.zero?
    end
    @upload_size += str.length
    str
  end
end