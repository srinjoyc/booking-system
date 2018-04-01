class ReservedTable < ApplicationRecord
  belongs_to :restaurant
  belongs_to :restaurant_table
  belongs_to :reservation
end
