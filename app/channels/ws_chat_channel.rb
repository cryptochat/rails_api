class WsChatChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  # example request
  #
  # { "command": "message",
  #   "identifier": "{\"channel\":\"WsChatChannel\"}",
  #   "data": "{\"cipher_message\":{\"data\":{\"recipient_id\":2,\"message_type\":\"text\",\"message\":\"Your message to recipient\"},\"action\":\"send_message\"}}"
  # }
  def send_message(data)
    data = OpenStruct.new(data['data'])
    ChatMessage.send_message(current_user.id, data.recipient_id, data.message)
  end
end
