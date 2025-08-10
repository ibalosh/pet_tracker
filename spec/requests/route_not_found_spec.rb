require "rails_helper"

RSpec.describe 'API not found', type: :request do
  it 'returns 404 for unknown v1 route' do
    get '/api/v1/does-not-exist'
    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['errors']).to include('Endpoint not found.')
  end
end
