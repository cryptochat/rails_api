class Encryption
  class << self
    def encrypt(message)
      if Settings.instance.encryption_enable
        message = message.is_a?(Hash) ? message.to_json : message
        key = CurrentConnection.instance.session_key.shared_key
        data = Cipher.encrypt(key, message)
        Base64.urlsafe_encode64(data)
      else
        message
      end
    end

    def decrypt(message, type: 'json')
      if Settings.instance.encryption_enable
        key = CurrentConnection.instance.session_key.shared_key
        message = Base64.urlsafe_decode64(message)
        data = Cipher.decrypt(key, message)

        if type == 'json'
          data = begin
            JSON.parse(data)
          rescue
            raise('JSON parse error')
          end
        end

        data
      else
        message
      end
    end
  end
end
