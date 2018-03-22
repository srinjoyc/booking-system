class RestaurantTable < ApplicationRecord
  belongs_to :restaurant
  
  validates_associated :restaurant
  validates :minimum_count, :maximum_count, :restaurant_id, presence: true
  before_save :valid_table_count

  private
    def valid_table_count
      maximum_count > minimum_count && minimum_count > 0
    end

end
