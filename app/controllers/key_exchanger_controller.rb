class KeyExchangerController < ApplicationController

  def get_public
    session_key = SessionKey.create
    render locals: { session_key: session_key }
  end

  def send_public
    errors =  {}
    errors[:public_key] = param! :public_key, String, required: true, format: Regex.base64
    errors[:public_key] ||= ('Invalid format' unless Validator.pub_key_valid_length?(params[:public_key]))
    errors[:uuid]       = param! :uuid,       String, required: true, format: Regex.uuid
    errors.compact!

    return render json: { errors: errors }, status: :bad_request if errors.present?

    session_key = SessionKey.exchange(params[:uuid], params[:public_key])
    return respond_404 'UUID not found' unless session_key.present?
    respond_200 'Successful key exchange'
  end

end
