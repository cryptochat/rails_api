class Jbuilder
  def encrypt!(*args, &block)
    cipher_message(::Encryption.encrypt(cipher_message(*args, &block)))
  end
end
