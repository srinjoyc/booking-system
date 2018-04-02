require 'date'

class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :guest
  belongs_to :restaurant_table
  has_one :reserved_table
  belongs_to :restaurant_shift

  validates_associated :restaurant, :guest, :restaurant_table, :restaurant_shift
  validates :guest_count, :reservation_time, :restaurant_id, :restaurant_shift_id, :restaurant_table_id, presence: true
  before_save :valid_guest_count

  def self.get_table restaurant_id, time, guest_count
    # get reservations 1 hour before and 1 hour after the given time
    reserved_table_ids = get_reserved_tables restaurant_id, time
    available_tables = RestaurantTable.where(restaurant_id: restaurant_id)
                                      .where('minimum_count <= ? AND maximum_count >= ?', guest_count, guest_count)
                                      .where.not(id: reserved_table_ids)
    available_tables.first
  end

  def self.reserve_table reservation, table
    ReservedTable.create!({
      reservation_id: reservation.id,
      reservation_time: reservation.reservation_time,
      restaurant_id: reservation.restaurant_id,
      restaurant_table_id: table.id,
    })
  end

  def self.get_reserved_tables restaurant_id, time
    # get reservations 1 hour before and 1 hour after the given time
    ReservedTable.joins(:restaurant_table)
                  .where(restaurant_id: restaurant_id)
                  .where(reservation_time: time - 3600...time + 3600)
                  .pluck(:restaurant_table_id).to_json
  end

private

  def valid_guest_count
    guest_count > 0
  end

end
