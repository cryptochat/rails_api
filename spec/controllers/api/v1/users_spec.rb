require 'spec_helper'
require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  render_views

  context 'registration' do
    it '-- request without identifier' do
      process :create, method: :post
      expect(response.status).to eq 400
      expect(response).to match_response_schema('identifier_not_present')
    end

    it '-- successful request' do
      session_key = FactoryGirl.create(:session_key)

      data = {}
      data[:email]      = 'example@gmail.com'
      data[:username]   = 'example_username'
      data[:password]   = 'example_password'
      data[:first_name] = 'example_first_name'
      data[:last_name]  = 'example_last_name'

      process :create, method: :post, params: {
          identifier: session_key.identifier,
          data: data.to_json
      }

      expect(response.status).to eq 201
      expect(response).to match_response_schema('users/create/ok')
    end
  end

  context 'authentication' do
    it '-- request without identifier' do
      process :auth, method: :post
      expect(response.status).to eq 400
      expect(response).to match_response_schema('identifier_not_present')
    end

    it '-- successful request' do
      session_key = FactoryGirl.create(:session_key)
      user = FactoryGirl.create(:user)

      data = {}
      data[:email]      = user.email
      data[:password]   = '123456'

      process :auth, method: :post, params: {
          identifier: session_key.identifier,
          data: data.to_json
      }

      expect(response.status).to eq 200
      expect(response).to match_response_schema('users/create/ok')
    end
  end
end
