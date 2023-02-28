# frozen_string_literal: true

class Sale < ApplicationRecord
  belongs_to :product, optional: false
  belongs_to :user, optional: false

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :product_id, presence: true
  validates :user_id, presence: true

  validates_with SaleValidator

  def delete
    transaction do
      product.rollback_stock(amount)
      destroy!
    end
  rescue ActiveRecord::ActiveRecordError
    errors.add(:base, :invalid)
  end

  def effect
    transaction do
      product.update_stock(amount)
      save!
    end
  rescue ActiveRecord::RecordInvalid
    errors.add(:base, :invalid)
  end

  def rectify(sale_params)
    transaction do
      product.rollback_stock(amount)
      update!(sale_params)
      product.update_stock(amount)
    end
  rescue ActiveRecord::ActiveRecordError
    errors.add(:base, :invalid)
  end
end
