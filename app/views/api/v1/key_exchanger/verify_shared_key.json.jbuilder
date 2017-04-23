json.identifier @session_key_server.identifier
json.shared_key_server Base64.urlsafe_encode64(@session_key_server.shared_key)
json.shared_key_client @session_key_client
json.shared_key_equals @session_key_server.shared_key == Base64.urlsafe_decode64(@session_key_client)
