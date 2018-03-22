class RestaurantShift < ApplicationRecord
  belongs_to :restaurant
  
  validates_associated :restaurant
  validates :start_time, :end_time, :name, :restaurant_id, presence: true
  before_save :has_no_conflicts

private
  def has_no_conflicts
    return true
  end
end
