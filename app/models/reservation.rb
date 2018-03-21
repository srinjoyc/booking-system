class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :guest
  belongs_to :restaurant_table
  belongs_to :restaurant_shift
end
