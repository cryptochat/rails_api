json.encrypt! do
  json.chats do
    json.array! @chats do |chat|
      json.interlocutor do
        obj = current_user.id == chat.user_id ? chat.interlocutor : chat.user
        json.extract! obj, :id, :username, :first_name, :last_name
      end
      json.last_message chat.text
      json.is_read chat.read?
      json.from_me current_user.id == chat.user_id
    end
  end
end
