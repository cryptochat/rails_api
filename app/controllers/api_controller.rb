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
    return respond_with 400, key: 'identifier', message: 'Not present' unless params[:identifier].present?
    find_session_key

    # если ключ идентификатора ключа шифрования не найден
    unless CurrentConnection.instance.session_key.present?
      return respond_with 404, key: 'identifier', message: 'Not found'
    end

    # если процедура обмена ключами не завершена
    unless CurrentConnection.instance.session_key.shared_key.present?
      return respond_with 404, key: 'identifier', message: 'Not have shared key'
    end

    CurrentConnection.instance.params = decrypt_params
  end
end
