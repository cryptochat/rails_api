class ApiController < ApplicationController
  include JsonErrorSerializer::Extenders::Controller
  include Decryptor
  include Checker

  before_action :set_default_response_format
  before_action :per_request, except: %i[get_public send_public]

  protected

  def set_default_response_format
    request.format = :json
  end

  private

  def per_request
    return respond_with 400, key: 'identifier', message: 'Not present', encryption: false unless params[:identifier].present?
    find_session_key

    # если ключ идентификатора ключа шифрования не найден
    unless CurrentConnection.instance.session_key.present?
      return respond_with 404, key: 'identifier', message: 'Not found', encryption: false
    end

    # если процедура обмена ключами не завершена
    unless CurrentConnection.instance.session_key.shared_key.present?
      return respond_with 404, key: 'identifier', message: 'Not have shared key', encryption: false
    end

    CurrentConnection.instance.params = decrypt_params
  end

  def auth_by_token
    return respond_with 403, key: 'token', message: 'Not present' unless CurrentConnection.instance.params[:token]

    token = Token.find_by(value: CurrentConnection.instance.params[:token])
    return respond_with 403, key: 'token', message: 'Not found' unless token.present?

    CurrentConnection.instance.user = token.user
  end

  def current_user
    CurrentConnection.instance.user
  end
end
