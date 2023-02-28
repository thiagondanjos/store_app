# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sale do
  it { is_expected.to belong_to(:product).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:value).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:product_id) }
  it { is_expected.to validate_presence_of(:user_id) }
end
