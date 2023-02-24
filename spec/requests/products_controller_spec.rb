# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController do
  let(:headers) { { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }
  let(:login_params) { { user: { email: user.email, password: user.password } } }
  let!(:product) { Product.create(name: 'product', stock: 10, value: 15.90) }
  let(:product_params) { { product: { name: 'other_product', stock: 20, value: 30 } } }
  let(:user) { User.create(email: Faker::Internet.email, name: Faker::Name.name, password: 'Lj8CqXSy') }

  describe 'GET /index' do
    context 'with invalid login' do
      it 'unauthorized' do
        get '/products', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        get '/products', headers: headers

        response_user_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_user_data.length).to eq(1)
      end
    end
  end

  describe 'GET /show' do
    context 'with invalid login' do
      it 'unauthorized' do
        get "/products/#{product.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        get "/products/#{product.id}", headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_data['id']).to eq(product.id)
        expect(response_data['name']).to eq(product.name)
        expect(response_data['stock']).to eq(product.stock)
        expect(response_data['value']).to eq(product.value)
      end

      it 'with invalid id' do
        get '/products/50', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('Product not found')
      end
    end
  end

  describe 'PATCH /update' do
    let(:update_params) { { product: { stock: 100, value: 85.50 } } }

    context 'with invalid login' do
      it 'unauthorized' do
        patch "/products/#{product.id}", params: update_params.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        patch "/products/#{product.id}", params: update_params.to_json, headers: headers

        product = Product.last

        expect(response).to have_http_status(:success)
        expect(product.stock).to eq(update_params[:product][:stock])
        expect(product.value).to eq(update_params[:product][:value])
      end

      it 'with invalid id' do
        get '/products/50', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('Product not found')
      end
    end
  end

  describe 'Delete /destroy' do
    let(:other_product) { Product.create(name: 'other_product', stock: 87, value: 55.40) }

    context 'with invalid login' do
      it 'unauthorized' do
        delete "/products/#{other_product.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        delete "/products/#{other_product.id}", headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_data['message']).to eq('Registration deleted successfully')
      end

      it 'with invalid id' do
        delete '/products/50', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('Product not found')
      end
    end
  end

  describe 'POST /create' do
    context 'with invalid login' do
      it 'unauthorized' do
        post '/products', params: product_params.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        post '/products', params: product_params.to_json, headers: headers

        product = Product.last

        expect(response).to have_http_status(:success)
        expect(product.name).to eq(product_params[:product][:name])
        expect(product.stock).to eq(product_params[:product][:stock])
        expect(product.value).to eq(product_params[:product][:value])
      end

      it 'with invalid data' do
        post '/products', params: { product: { name: '', stock: '', value: '' } }.to_json, headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_data['name'][0]).to eq("can't be blank")
        expect(response_data['stock'][0]).to eq("can't be blank")
        expect(response_data['value'][0]).to eq("can't be blank")
      end
    end
  end
end
