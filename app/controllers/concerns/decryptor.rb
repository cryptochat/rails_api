module Decryptor
  include ActiveSupport::Concern

  def find_session_key
    CurrentConnection.instance.session_key = SessionKey.find_by(identifier: params[:identifier])
  end

  def decrypt_params
    return params unless params[:data].present?
    data = params[:data]

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

    hash = params.except(:data)
    hash.merge(JSON.parse(data))
  end

  def serialize_encrypt_data(model, *params)
    data = {}
    params.each do |param|
      data[param] = model.send(param)
    end

    Settings.instance.encryption_enable ? Encryption.encrypt(data.to_json) : data
  end
end
