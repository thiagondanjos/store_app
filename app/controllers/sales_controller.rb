# frozen_string_literal: true

class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: %i[show update destroy]

  def index
    @sales = Sale.all
  end

  def show
    render json: @sale
  end

  def create
    @sale = Sale.new(sale_params)
    @sale.effect

    if @sale.errors.any?
      render json: @sale.errors, status: :unprocessable_entity
    else
      render :show, status: :created, location: @sale
    end
  end

  def update
    @sale.rectify(sale_params)

    if @sale.errors.any?
      render json: @sale.errors, status: :unprocessable_entity
    else
      render :show, status: :ok, location: @sale
    end
  end

  def destroy
    @sale.delete

    if @sale.errors.any?
      render json: @sale.errors, status: :unprocessable_entity
    else
      render json: { message: 'Registration deleted successfully' }, status: :ok
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
end
