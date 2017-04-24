module Decryptor
  include ActiveSupport::Concern

  ALLOW_PARAMETERS = %i[controller action identifier public_key shared_key data]

  def find_session_key
    CurrentConnection.instance.session_key = SessionKey.find_by(identifier: params[:identifier])
  end

  def decrypt_params
    tmp = params.slice(*ALLOW_PARAMETERS)
    return tmp unless tmp[:data].present?
    data = tmp[:data]

    if Settings.instance.encryption_enable
      data = begin
        res = Encryption.decrypt(params[:data])
        return respond_with 415, key: 'shared_key', message: 'Not valid' unless valid_json?(res)
        res
      rescue
        return respond_with 415, key: 'decryptor', message: 'Can\'t decrypt the message'
      end
    else
      return respond_with 406, key: 'data', message: 'json invalid' unless valid_json?(data)
    end

    hash = tmp.except(:data)
    hash.merge(JSON.parse(data))
  end
end
