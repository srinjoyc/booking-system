class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :guest
  belongs_to :restaurant_table
  belongs_to :restaurant_shift

  validates_associated :restaurant, :guest, :restaurant_table, :restaurant_shift
  validates :guest_count, :reservation_time, :restaurant_id, :restaurant_shift_id, :restaurant_table_id, presence: true
  before_save :valid_guest_count

private
  def valid_guest_count
    guest_count > 0
  end
end
