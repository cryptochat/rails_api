class ApiController < ApplicationController
  include JsonErrorSerializer::Extenders::Controller
  include Decryptor
  include Checker
  include Authenticator

  before_action :set_default_response_format
  before_action :per_request, except: [:get_public, :send_public]

  protected

  def set_default_response_format
    request.format = :json
  end

  private

  def per_request
    $encryption_enable = false

    return respond_with 400, key: 'identifier', message: 'Not present' unless params[:identifier].present?
    $session_key = find_session_key

    return respond_with 404, key: 'identifier', message: 'Not found' unless $session_key.present?
    return respond_with 404, key: 'identifier', message: 'Not have shared key' unless $session_key.shared_key.present?

    $params = decrypt_params
  end
end
