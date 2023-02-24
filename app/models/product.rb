# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, presence: true
  validates :stock, presence: true
  validates :value, presence: true
end
