json.encrypt! do
  json.chats do
    json.array! @chats do |chat|
      json.interlocutor do
        user = current_user.id == chat.user_id ? chat.interlocutor : chat.user
        json.id         user.id
        json.username   user.username
        json.first_name user.first_name
        json.last_name  user.last_name
        json.is_online  user.is_online
        json.avatar     user.avatar
      end
      json.last_message chat.text
      json.is_read chat.read?
      json.from_me current_user.id == chat.user_id
      json.created_at chat.created_at.to_i
    end
  end
end
