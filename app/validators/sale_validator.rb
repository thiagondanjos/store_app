# frozen_string_literal: true

class SaleValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:amount, 'insufficient product stock') if insufficient_product_stock?(record)
    record.errors.add(:value, 'value does not match product price') if valid_value?(record)
  end

  private

  def insufficient_product_stock?(record)
    return if record.product.nil?

    record.product.stock < record.amount
  end

  def valid_value?(record)
    return if record.product.nil?

    record.product.value * record.amount != record.value
  end
end
