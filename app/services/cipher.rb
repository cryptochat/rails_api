class Cipher
  class << self
    def encrypt(key, message)
      AESCrypt.encrypt(message, key)
    end

    def decrypt(key, message)
      AESCrypt.decrypt(message, key)
    end
  end
end
