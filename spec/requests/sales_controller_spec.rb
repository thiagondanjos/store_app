# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SalesController do
  let(:headers) { { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }
  let(:login_params) { { user: { email: user.email, password: user.password } } }
  let(:product) { Product.create(name: 'product', stock: 10, value: 15) }
  let!(:sale) { Sale.create(amount: 1, value: 15, product_id: product.id, user_id: user.id) }
  let(:sale_params) { { sale: { amount: 2, value: 30, product_id: product.id, user_id: user.id } } }
  let(:user) { User.create(email: Faker::Internet.email, name: Faker::Name.name, password: 'Lj8CqXSy') }

  describe 'GET /index' do
    context 'with invalid login' do
      it 'unauthorized' do
        get '/sales', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        get '/sales', headers: headers

        response_user_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_user_data.length).to eq(1)
      end
    end
  end

  describe 'GET /show' do
    context 'with invalid login' do
      it 'unauthorized' do
        get "/sales/#{sale.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        get "/sales/#{sale.id}", headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_data['id']).to eq(sale.id)
        expect(response_data['amount']).to eq(sale.amount)
        expect(response_data['value']).to eq(sale.value)
        expect(response_data['product_id']).to eq(sale.product_id)
        expect(response_data['user_id']).to eq(sale.user_id)
      end

      it 'with invalid id' do
        get '/sales/50', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('Sale not found')
      end
    end
  end

  describe 'POST /create' do
    context 'with invalid login' do
      it 'unauthorized' do
        post '/sales', params: sale_params.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      let(:other_product) { Product.create(name: 'other_product', stock: 0, value: 10) }
      let(:incorrect_sale_params) { { sale: { amount: 2, value: 1, product_id: other_product.id, user_id: user.id } } }

      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        post '/sales', params: sale_params.to_json, headers: headers

        sale = Sale.last
        product = Product.last

        expect(response).to have_http_status(:success)
        expect(sale.amount).to eq(sale_params[:sale][:amount])
        expect(sale.value).to eq(sale_params[:sale][:value])
        expect(sale.product_id).to eq(sale_params[:sale][:product_id])
        expect(sale.user_id).to eq(sale_params[:sale][:user_id])
        expect(product.stock).to eq(7)
      end

      it 'with invalid data' do
        post '/sales', params: incorrect_sale_params.to_json, headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_data['amount'][0]).to eq('insufficient product stock')
        expect(response_data['value'][0]).to eq('value does not match product price')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with invalid login' do
      it 'unauthorized' do
        patch "/sales/#{sale.id}", params: sale_params.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        patch "/sales/#{sale.id}", params: sale_params.to_json, headers: headers

        sale = Sale.last

        expect(response).to have_http_status(:success)
        expect(sale.amount).to eq(sale_params[:sale][:amount])
        expect(sale.value).to eq(sale_params[:sale][:value])
        expect(sale.product_id).to eq(sale_params[:sale][:product_id])
        expect(sale.user_id).to eq(sale_params[:sale][:user_id])
      end

      it 'with invalid id' do
        patch '/sales/50', params: sale_params.to_json, headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('Sale not found')
      end
    end
  end

  describe 'Delete /destroy' do
    context 'with invalid login' do
      it 'unauthorized' do
        delete "/sales/#{sale.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid login' do
      before { post '/login', params: login_params.to_json, headers: headers }

      it 'successfull' do
        delete "/sales/#{sale.id}", headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_data['message']).to eq('Registration deleted successfully')
      end

      it 'with invalid id' do
        delete '/sales/50', headers: headers

        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_data['message']).to eq('Sale not found')
      end
    end
  end
end
