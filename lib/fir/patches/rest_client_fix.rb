# frozen_string_literal: true

# Fix for rest-client 2.1.0 compatibility with Ruby 2.6/2.7
# The bug: In some cases, @response is a String instead of a response object,
# causing NoMethodError when calling @response.code in http_code method.
#
# See: https://github.com/rest-client/rest-client/issues/...
module RestClient
  class Exception
    def http_code
      # return integer for compatibility
      if @response
        # Handle case where @response is a String (e.g., "401 Unauthorized")
        # or when @response is a proper response object
        code = if @response.respond_to?(:code)
                 @response.code
               else
                 @response.to_s[/\d{3}/]
               end
        code.to_i
      else
        @initial_response_code
      end
    end
  end
end
