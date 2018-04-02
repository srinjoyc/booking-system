class RestaurantTable < ApplicationRecord
  belongs_to :restaurant

  validates_associated :restaurant
  validates :minimum_count, :maximum_count, :restaurant_id, presence: true
  before_save :valid_table_count


  def check_guest_count guest_count
    if guest_count > maximum_count
      self.errors.add(:table, "too many guests, maximum #{maximum_count}")
      return false
    end
    if guest_count < minimum_count
      self.errors.add(:table, "too few guests, minimum #{minimum_count}")
      return false
    end
    return true
  end

  private
    def valid_table_count
      maximum_count > minimum_count && minimum_count > 0
    end
end
