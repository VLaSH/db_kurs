class Product < ApplicationRecord
  has_many :deliveries
  belongs_to :category
  has_one :availability
end
