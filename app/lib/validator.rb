class Validator
  class << self
    def is_uuid?(string)
      if string =~ Regex.uuid
        true
      else
        false
      end
    end

    def is_base64?(string)
      if string =~ Regex.base64
        true
      else
        false
      end
    end

    def pub_key_valid_length?(base64_string)
      string = Base64.urlsafe_decode64(base64_string)
      string.bytesize == 32 ? true : false
    end
  end
end
