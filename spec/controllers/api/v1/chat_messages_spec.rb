require 'spec_helper'
require 'rails_helper'

describe Api::V1::ChatMessagesController, type: :controller do
  render_views

  context 'chat_list' do
    it '-- request without identifier' do
      process :chat_list, method: :get
      expect(response.status).to eq 400
      expect(response).to match_response_schema('identifier_not_present')
    end

    it '-- request without token' do
      session_key = FactoryGirl.create(:session_key)
      process :chat_list, method: :get, params: {
          identifier: session_key.identifier
      }

      expect(response.status).to eq 403
    end

    it '-- successful request' do
      user1 = FactoryGirl.create(:user, :with_token)
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)

      # создаем историю переписки
      ChatMessage.send_message(user1.id, user2.id, 'message1')
      ChatMessage.send_message(user1.id, user3.id, 'message2')
      ChatMessage.send_message(user3.id, user1.id, 'message3')

      data = {}
      data[:token] = user1.token

      session_key = FactoryGirl.create(:session_key)
      process :chat_list, method: :get, params: {
          identifier: session_key.identifier,
          data: data.to_json
      }

      result = JSON.parse(response.body, object_class: OpenStruct)

      expect(response.status).to eq 200
      expect(response).to match_response_schema('chat_messages/chat_list')
      expect(result.cipher_message.chats.count).to eq 2
      expect(result.cipher_message.chats[0].last_message).to eq 'message3'
    end
  end

  context 'chat messages (index)' do
    it '-- request without identifier' do
      process :index, method: :get
      expect(response.status).to eq 400
      expect(response).to match_response_schema('identifier_not_present')
    end

    it '-- request without token' do
      session_key = FactoryGirl.create(:session_key)
      process :index, method: :get, params: {
          identifier: session_key.identifier
      }

      expect(response.status).to eq 403
    end

    it '-- request without interlocutor_id' do
      user = FactoryGirl.create(:user, :with_token)

      data = {}
      data[:token] = user.token

      session_key = FactoryGirl.create(:session_key)
      process :index, method: :get, params: {
          identifier: session_key.identifier,
          data: data.to_json
      }

      expect(response.status).to eq 400
    end

    it '-- successful request' do
      user1 = FactoryGirl.create(:user, :with_token)
      user2 = FactoryGirl.create(:user)

      # создаем историю переписки
      ChatMessage.send_message(user1.id, user2.id, 'message1')

      data = {}
      data[:token] = user1.token
      data[:interlocutor_id] = user2.id

      session_key = FactoryGirl.create(:session_key)
      process :index, method: :get, params: {
          identifier: session_key.identifier,
          data: data.to_json
      }

      expect(response.status).to eq 200
      expect(response).to match_response_schema('chat_messages/chat_messages')
    end

    it '-- limit and offset' do
      user1 = FactoryGirl.create(:user, :with_token)
      user2 = FactoryGirl.create(:user)

      # создаем историю переписки
      ChatMessage.send_message(user1.id, user2.id, 'message1')
      ChatMessage.send_message(user1.id, user2.id, 'message2')
      ChatMessage.send_message(user2.id, user1.id, 'message3')
      ChatMessage.send_message(user2.id, user1.id, 'message4')
      ChatMessage.send_message(user2.id, user1.id, 'message5')
      ChatMessage.send_message(user2.id, user1.id, 'message6')

      data = {}
      data[:token] = user1.token
      data[:interlocutor_id] = user2.id

      session_key = FactoryGirl.create(:session_key)
      # должны получить все 6 сообщений
      process :index, method: :get, params: {
          identifier: session_key.identifier,
          data: data.to_json
      }

      first_result = JSON.parse(response.body, object_class: OpenStruct)

      expect(response.status).to eq 200
      expect(response).to match_response_schema('chat_messages/chat_messages')
      expect(first_result.cipher_message.messages.count).to eq 6

      # тестируем limit
      data[:limit] = 5
      process :index, method: :get, params: {
          identifier: session_key.identifier,
          data: data.to_json
      }

      second_result = JSON.parse(response.body, object_class: OpenStruct)
      msg_1 = second_result.cipher_message.messages[1].message.text
      expect(response.status).to eq 200
      expect(response).to match_response_schema('chat_messages/chat_messages')
      expect(second_result.cipher_message.messages.count).to eq 5

      # тестируем offset
      data[:offset] = 1
      process :index, method: :get, params: {
          identifier: session_key.identifier,
          data: data.to_json
      }

      third_result = JSON.parse(response.body, object_class: OpenStruct)
      msg_2 = third_result.cipher_message.messages[0].message.text
      expect(response.status).to eq 200
      expect(response).to match_response_schema('chat_messages/chat_messages')
      expect(msg_2).to eq msg_1
    end
  end
end
