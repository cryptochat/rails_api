module Api::V1
  class ChatMessagesController < ApiController
    before_action :auth_by_token

    def index
      unless chat_message_params[:interlocutor_id].present?
        return respond_with 400, key: 'interlocutor_id', message: 'Not present'
      end

      @chat_messages = ChatMessage.history(current_user.id,
                                           chat_message_params[:interlocutor_id],
                                           chat_message_params[:offset],
                                           chat_message_params[:limit])

      render locals: { current_user: current_user }
    end

    def chat_list
      @chats = current_user.chat_list
      render locals: { current_user: current_user }
    end

    def chat_message_params
      CurrentConnection.instance.params.permit(:interlocutor_id, :offset, :limit)
    end
  end
end
