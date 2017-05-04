json.encrypt! do
  json.status 'OK'
  json.user do
    json.first_name @user.first_name
    json.last_name @user.last_name
    json.avatar @user.avatar
  end
end
