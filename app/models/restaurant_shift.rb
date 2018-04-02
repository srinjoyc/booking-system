class RestaurantShift < ApplicationRecord
  belongs_to :restaurant

  validates_associated :restaurant
  validates :start_time, :end_time, :name, :restaurant_id, presence: true
  before_save :check_times


def self.restaurant_shift_string restaurant_id
  shift_times = Restaurant.find(restaurant_id).restaurant_shifts
  msg = shift_times.map { |shift|
    "The #{shift.name} is from #{shift.start_time} to #{shift.end_time}"
  }.to_s
end

private
  def check_times
    self.end_time > start_time # since times are hours from 1 - 24
  end
end
