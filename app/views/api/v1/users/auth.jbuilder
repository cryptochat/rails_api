json.status 'OK'
json.data serialize_encrypt_data(@user, :uuid, :email, :username, :first_name, :last_name, :token)
