module ApplicationHelper
  def serialize_encrypt_data(model, *params)
    data = {}
    params.each do |param|
      data[param] = model.send(param)
    end

    Settings.instance.encryption_enable ? Encryption.encrypt($session_key.shared_key, data) : data
  end
end
