# frozen_string_literal: true

class Sale < ApplicationRecord
  belongs_to :product, optional: false
  belongs_to :user, optional: false

  validates :amount, presence: true
  validates :value, presence: true
  validates :product_id, presence: true
  validates :user_id, presence: true

  validates_with SaleValidator

  after_save :update_stock

  def update_stock
    product.update_stock(amount)
  end
end
