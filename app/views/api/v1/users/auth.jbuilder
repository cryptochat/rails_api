json.encrypt! do
  json.status 'OK'
  json.user do
    json.id @user.id
    json.uuid @user.uuid
    json.email @user.email
    json.username @user.username
    json.first_name @user.first_name
    json.last_name @user.last_name
    json.token @user.token
    json.avatar @user.avatar
  end
end
