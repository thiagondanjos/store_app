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

  describe 'GET /show' do
    before do
      post '/login', params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end

    it 'returns http success' do
      get "/users/#{user.id}", headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

      expect(response).to have_http_status(:success)
    end
  end
end
