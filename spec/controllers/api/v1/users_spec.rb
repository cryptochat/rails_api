require 'spec_helper'
require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  render_views

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
      expect(response).to match_response_schema('users/create/auth')
    end
  end
end
