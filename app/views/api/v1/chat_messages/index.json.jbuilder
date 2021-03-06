json.encrypt! do
  json.messages do
    json.array! @chat_messages do |msg|
      json.user do
        json.id msg.user.id
        json.username msg.user.username
        json.first_name msg.user.first_name
        json.last_name msg.user.last_name
        json.is_online msg.user.is_online
        json.avatar msg.user.avatar
      end
      json.message do
        json.text msg.text
        json.created_at msg.created_at.to_i
        json.from_me current_user.id ==  msg.user_id
      end
    end
  end
end
