class Delivery < ApplicationRecord
  belongs_to :provider
  belongs_to :product
end
