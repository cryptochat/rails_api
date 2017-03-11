require 'spec_helper'
require 'rails_helper'

describe Api::V1::KeyExchangerController, type: :controller do
  render_views

  context 'get_public' do
    it '-- return public_key and identifier for exchange' do
      get 'get_public'

      expect(response.status).to eq 200
      expect(response).to match_response_schema('key_exchanger/get_public/ok')
    end
  end

  context 'send_public' do
    it '-- successful exchange' do
      session_key = FactoryGirl.create(:session_key)
      process :send_public, method: :post, params: {
          identifier: session_key.identifier,
          public_key: session_key.base64_public_key
      }
      expect(response.status).to eq 200
    end

    it '-- invalid public key' do
      session_key = FactoryGirl.create(:session_key)
      process :send_public, method: :post, params: {
          identifier: session_key.identifier,
          public_key: session_key.base64_public_key[1..10]
      }
      expect(response.status).to eq 400
    end

    it '-- invalid identifier key' do
      session_key = FactoryGirl.create(:session_key)
      process :send_public, method: :post, params: {
          identifier: session_key.identifier[1..10],
          public_key: session_key.base64_public_key
      }
      expect(response.status).to eq 400
    end

    it '-- identifier not found' do
      session_key = FactoryGirl.create(:session_key)
      identifier = '6713916c-0000-43c8-aede-4f04c42c2c49'
      process :send_public, method: :post, params: {
          identifier: identifier,
          public_key: session_key.base64_public_key
      }
      expect(response.status).to eq 404
    end

    it '-- identifier not present' do
      session_key = FactoryGirl.create(:session_key)
      process :send_public, method: :post, params: { public_key: session_key.base64_public_key }
      expect(response.status).to eq 400
    end

    it '-- public_key not present' do
      session_key = FactoryGirl.create(:session_key)
      process :send_public, method: :post, params: { identifier: session_key.identifier }
      expect(response.status).to eq 400
    end
  end
end
