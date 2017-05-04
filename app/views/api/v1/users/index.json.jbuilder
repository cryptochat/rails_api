json.encrypt! do
  json.users do
    json.array! @users do |user|
      json.extract! user, :id, :username, :first_name, :last_name, :avatar
    end
  end
end
