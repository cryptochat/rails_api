module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      current_user.appear if current_user.present?
    end

    def disconnect
      current_user.disappear if current_user.present?
    end

    protected

    def find_verified_user
      return reject_unauthorized_connection unless find_session_key.present?

      token = decrypt_token
      return reject_unauthorized_connection unless token.present?

      if (current_user = User.joins(:tokens).where(tokens: { value: token }).take)
        current_user
      else
        reject_unauthorized_connection
      end
    end

    private

    def find_session_key
      identifier = request.params[:identifier]
      session_key = SessionKey.find_by(identifier: identifier)
      return nil unless session_key.present?
      return nil unless session_key.shared_key.present?
      CurrentConnection.instance.session_key = session_key
    end

    def decrypt_token
      return request.params[:token] unless Settings.instance.encryption_enable
      Encryption.decrypt(request.params[:token], type: 'plain')
    end
  end
end
