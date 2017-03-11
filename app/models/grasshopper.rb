class Grasshopper

  def self.encrypt(key, message)
    AESCrypt.encrypt(message, key)
  end

  def self.decrypt(key, message)
    AESCrypt.decrypt(message, key)
  end

end
