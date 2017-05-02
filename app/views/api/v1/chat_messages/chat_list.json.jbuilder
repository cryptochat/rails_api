json.encrypt! do
  json.chats do
    json.array! @chats do |chat|
      json.interlocutor do
        interlocutor = current_user.id == chat.user_id ? 'interlocutor' : 'user'
        json.id         chat.send("#{interlocutor}_id")
        json.username   chat.send("#{interlocutor}_username")
        json.first_name chat.send("#{interlocutor}_first_name")
        json.last_name  chat.send("#{interlocutor}_last_name")
        json.is_online  chat.send("#{interlocutor}_is_online")
      end
      json.last_message chat.text
      json.is_read chat.read?
      json.from_me current_user.id == chat.user_id
    end
  end
end
