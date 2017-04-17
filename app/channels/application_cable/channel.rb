module ApplicationCable
  class Channel < ActionCable::Channel::Base

    def perform_action(data)
      data = decrypt(data['cipher_message'])
      super(data)
    end

    def transmit(data, via: nil)
      data = encrypt(data)
      super(data, via: via)
    end

    private

    def encrypt(data)
      Encryption.encrypt(data)
    end

    def decrypt(data)
      Encryption.decrypt(data)
    end
  end
end
