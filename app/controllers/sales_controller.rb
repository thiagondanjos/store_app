# frozen_string_literal: true

class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: %i[show update destroy]
  before_action :update_stock, only: %i[update destroy]

  def index
    @sales = Sale.all
  end

  def show
    render json: @sale
  end

  def create
    @sale = Sale.new(sale_params)

    if @sale.save
      render :show, status: :created, location: @sale
    else
      render json: @sale.errors, status: :unprocessable_entity
    end
  end

  def update
    if @sale.update(sale_params)
      render :show, status: :ok, location: @sale
    else
      render json: @sale.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @sale.destroy
      render json: { message: 'Registration deleted successfully' }, status: :ok
    else
      render json: @sale.errors, status: :unprocessable_entity
    end
  end

  private

  def sale_params
    params.require(:sale).permit(:amount, :value, :user_id, :product_id)
  end

  def set_sale
    @sale = Sale.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Sale not found' }, status: :not_found
  end

  def update_stock
    @sale.product.restore_stock(@sale.amount)
  end
end
