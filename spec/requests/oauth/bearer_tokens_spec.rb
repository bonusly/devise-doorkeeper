require 'rails_helper'

RSpec.describe 'OAuth bearer token requests', type: :request do
  let(:request_path) { '/example.json' }
  context 'with valid access token' do
    with :access_token
    let(:headers) do
      {
        'Authorization' => "Bearer #{access_token.token}"
      }
    end
    let(:params) { {} }
    before do
      get request_path, params, headers
    end
    it { expect(response.status).to eq 200 }
  end
  context 'with expired access token' do
    with :access_token, expires_in: 0
    let(:headers) do
      {
        'Authorization' => "Bearer #{access_token.token}"
      }
    end
    let(:params) { {} }
    before do
      get request_path, params, headers
    end
    it { expect(response.status).to eq 401 }
  end
  context 'with revoked access token' do
    with :access_token, revoked_at: 1.year.ago
    let(:headers) do
      {
        'Authorization' => "Bearer #{access_token.token}"
      }
    end
    let(:params) { {} }
    before do
      get request_path, params, headers
    end
    it { expect(response.status).to eq 401 }
  end
  context 'with invalid access token' do
    let(:access_token) { double(:fake_token, token: 'invalid') }
    let(:headers) do
      {
        'Authorization' => "Bearer #{access_token.token}"
      }
    end
    let(:params) { {} }
    before do
      get request_path, params, headers
    end
    it { expect(response.status).to eq 401 }
  end
end