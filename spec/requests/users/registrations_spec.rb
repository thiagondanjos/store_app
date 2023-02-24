# frozen_string_literal: true

require 'rails_helper'

describe 'user registrations' do
  let(:headers) { { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }
  let(:invalid_params) { { user: { password: 'H1LPrxEDsZ' } } }
  let(:params) { { user: { name: Faker::Name.name, email: Faker::Internet.email, password: 'H1LPrxEDsZ' } } }

  context 'signup' do
    it 'successfull' do
      post '/signup', params: params.to_json, headers: headers

      expect(response).to have_http_status :ok
    end

    it 'not successfull' do
      post '/signup', params: invalid_params.to_json, headers: headers

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
