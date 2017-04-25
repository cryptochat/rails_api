module Api::V1
  class ChatMessagesController < ApiController
    before_action :auth_by_token

    def index
      # code
    end

    def chat_list
      @chats = current_user.chat_list
      render locals: { current_user: current_user }
    end
  end
end
