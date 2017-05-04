json.header do
  json.method_name  method_name
end
json.body do
  json.text         message.text
  json.created_at   message.created_at.to_i
  json.sender do
    json.id         message.sender.id
    json.first_name message.sender.first_name
    json.last_name  message.sender.last_name
    json.username   message.sender.username
    json.avatar     message.sender.avatar
  end
end
