module Decryptor
  include ActiveSupport::Concern

  def find_session_key
    SessionKey.find_by(identifier: params[:identifier])
  end

  def decrypt_params
    return params unless params[:data].present?
    data = params[:data]

    if $encryption_enable
      data = begin
        res = Grasshopper.decrypt($session_key.shared_key, params[:data])
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

    $encryption_enable ? Grasshopper.encrypt($session_key.shared_key, data) : data
  end
end
