class RestaurantShift < ApplicationRecord
  belongs_to :restaurant

  validates_associated :restaurant
  validates :start_time, :end_time, :name, :restaurant_id, presence: true
  before_save :has_no_conflicts


def self.restaurant_shift_string restaurant_id
  shift_times = restaurant.restaurant_shifts
  msg = ""
  msg += shift_times.map { |shift|
    "The #{shift.name} is from #{shift.start_time} to #{shift.end_time}"
  }
end
private
  def has_no_conflicts
    return true
  end
end
