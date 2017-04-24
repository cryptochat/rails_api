module Api::V1
  # Контроллер отвечающий за формирование общего ключа шифрования
  class KeyExchangerController < ApiController
    def get_public
      session_key = SessionKey.create
      render locals: { session_key: session_key }
    end

    def send_public
      errors = {}
      errors[:public_key] = param! :public_key, String, required: true, format: Regex.base64_urlsafe
      errors[:identifier] = param! :identifier, String, required: true, format: Regex.uuid

      # проверяем что длина расшифрованного public_key из Base64 равна 32
      errors[:public_key] ||= 'LengthError (Expected 32)' unless Validator.pub_key_valid_length?(params[:public_key])

      errors.compact!

      return render json: { status: '400', errors: errors }, status: :bad_request if errors.present?

      session_key = SessionKey.exchange(params[:identifier], params[:public_key])
      return respond_with 404, key: 'identifier', message: 'Not found', encryption: false unless session_key.present?
      respond_with 200, encryption: false
    end

    # использовать только в dev режиме!
    def verify_shared_key
      return respond_with 400, key: 'session_key', message: 'Not present' unless params[:session_key].present?

      @session_key_client = params[:session_key]
      @session_key_server = SessionKey.find_by(identifier: params[:identifier])
      return respond_with 404, key: 'identifier', message: 'Not found', encryption: false unless @session_key_server.present?

      render status: :ok
    end
  end
end
