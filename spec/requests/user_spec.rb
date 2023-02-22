# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  let(:user) { User.create(email: 'pedro_oliveira@2registrocivil.com.br', name: 'Pedro Oliveira', password: '12345678') }

  let(:params) do
    {
      user: {
        name: user.name,
        email: user.email,
        password: user.password
      }
    }
  end

  before do
    post '/login', params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/user', headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

      response_user_data = JSON.parse(response.body)['user']

      expect(response).to have_http_status(:success)
      expect(response_user_data['id']).to eq(user.id)
      expect(response_user_data['name']).to eq(user.name)
      expect(response_user_data['email']).to eq(user.email)
    end
  end

  describe 'PATCH /update' do
    let(:update_params) { { user: { name: 'Pedro' } } }

    it 'returns http success' do
      patch '/user', params: update_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

      response_user_data = JSON.parse(response.body)['user']

      expect(response).to have_http_status(:success)
      expect(response_user_data['id']).to eq(user.id)
      expect(response_user_data['name']).to eq('Pedro')
      expect(response_user_data['email']).to eq(user.email)
    end
  end

  describe 'Delete /destroy' do
    it 'returns http success' do
      delete '/user', headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(response_body[:message]).to eq('Registration deleted successfully')
    end
  end
end
