# frozen_string_literal: true

require 'rails_helper'

describe 'user registrations' do
  let(:params) do
    {
      user: {
        name: 'Pedro Oliveira',
        email: 'pedro_oliveira@2registrocivil.com.br',
        password: 'H1LPrxEDsZ'
      }
    }
  end

  context 'signup' do
    it 'successfull' do
      post '/signup', params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

      expect(response).to have_http_status :ok
    end

    it 'not successfull' do
      post '/signup', params: { user: { password: 'H1LPrxEDsZ' } }.to_json,
                      headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
