require 'spec_helper'
require 'rails_helper'

describe KeyExchangerController, type: :controller do
  render_views

  it 'return public_key and uuid for exchange' do
    get 'get_public', format: :json

    expect(response.status).to eq 200
    expect(response).to match_response_schema('key_get_public')
  end
end
