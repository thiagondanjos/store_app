# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, presence: true
  validates :stock, presence: true
  validates :value, presence: true

  def update_stock(amount)
    remaining_stock = stock - amount
    updated_stock = [remaining_stock, 0].max
    update!(stock: updated_stock)
  end

  def rollback_stock(amount)
    updated_stock = stock + amount
    update!(stock: updated_stock)
  end
end
