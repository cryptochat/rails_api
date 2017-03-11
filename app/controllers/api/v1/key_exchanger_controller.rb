class Api::V1::KeyExchangerController < ApiController
  def get_public
    session_key = SessionKey.create
    render locals: { session_key: session_key }
  end

  def send_public
    errors = {}
    errors[:public_key] = param! :public_key, String, required: true, format: Regex.base64
    errors[:identifier] = param! :identifier, String, required: true, format: Regex.uuid
    errors.compact!

    return render json: { status: '400', errors: errors }, status: :bad_request if errors.present?

    session_key = SessionKey.exchange(params[:identifier], params[:public_key])
    return respond_with 404, key: 'identifier', message: 'Not found' unless session_key.present?
    respond_with 200
  end
end
