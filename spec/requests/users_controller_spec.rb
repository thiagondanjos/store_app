# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  let(:headers) { { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }
  let(:login_params) { { user: { email: user.email, password: user.password } } }
  let(:user) { User.create(email: Faker::Internet.email, name: Faker::Name.name, password: 'Lj8CqXSy') }

  describe 'GET /index' do
    context 'with invalid login' do
      it 'unauthorized' do
        get '/users', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        get '/users', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_data.length).to eq(1)
      end
    end
  end

  describe 'GET /show' do
    context 'with invalid login' do
      it 'unauthorized' do
        get "/users/#{user.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        get "/users/#{user.id}", headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_data['id']).to eq(user.id)
        expect(response_data['name']).to eq(user.name)
        expect(response_data['email']).to eq(user.email)
      end

      it 'with invalid id' do
        get '/users/50', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('User not found')
      end
    end
  end

  describe 'PATCH /update' do
    let(:update_params) { { user: { email: Faker::Internet.email, name: Faker::Name.name } } }

    context 'with invalid login' do
      it 'unauthorized' do
        patch "/users/#{user.id}", params: update_params.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        patch "/users/#{user.id}", params: update_params.to_json, headers: headers

        user = User.last

        expect(response).to have_http_status(:success)
        expect(user.name).to eq(update_params[:user][:name])
        expect(user.email).to eq(update_params[:user][:email])
      end

      it 'with invalid id' do
        get '/users/50', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('User not found')
      end
    end
  end

  describe 'Delete /destroy' do
    let(:other_user) { User.create(email: Faker::Internet.email, name: Faker::Name.name, password: 'E6Kmjx35') }

    context 'with invalid login' do
      it 'unauthorized' do
        delete "/users/#{other_user.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        delete "/users/#{other_user.id}", headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_data['message']).to eq('Registration deleted successfully')
      end

      it 'with invalid id' do
        delete '/users/50', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('User not found')
      end
    end
  end
end
