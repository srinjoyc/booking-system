require 'date'

class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :guest
  belongs_to :restaurant_table
  has_one :reserved_table, dependent: :destroy
  belongs_to :restaurant_shift

  validates_associated :restaurant, :guest, :restaurant_table, :restaurant_shift
  validates :guest_count, :reservation_time, :restaurant_id, :restaurant_shift_id, :restaurant_table_id, presence: true

  before_save :valid_guest_count
  before_update :check_update
  after_save :create_reserved_table

  def self.get_table restaurant_id, time, guest_count
    # get reservations 1 hour before and 1 hour after the given time
    reserved_table_ids = get_reserved_tables restaurant_id, time
    available_tables = RestaurantTable.where(restaurant_id: restaurant_id)
                                      .where.not(id: reserved_table_ids.to_json)
                                      .where('minimum_count <= ? AND maximum_count >= ?', guest_count, guest_count)

    available_tables = available_tables.select { |table|
      !reserved_table_ids.include?(table.id.to_i)
    }
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
                  .pluck(:restaurant_table_id)
  end

private

  def valid_guest_count
    guest_count > 0
  end

  def check_update
    current_reservation = Reservation.find(self.id)
    table = RestaurantTable.find(self.restaurant_table_id)
    restaurant = Restaurant.find(self.restaurant_id)
    # guest count change
    if current_reservation.guest_count != self.guest_count
      correct_table_count = table.check_guest_count self.guest_count
      if !correct_table_count
        self.errors.add(:update, "Cannot update guest count to the requested number")
        raise ActiveRecord::Rollback
      end
    end
    # table change
    if current_reservation.restaurant_table_id != self.restaurant_table_id
      reserved_table_ids = Reservation.get_reserved_tables self.restaurant_id, self.reservation_time
      not_reserved_table = reserved_table_ids.include?(self.restaurant_table_id)
      if !not_reserved_table
        self.errors.add(:update, "Table already booked")
        raise ActiveRecord::Rollback
      end
    end
    # shift change
    if current_reservation.restaurant_shift_id != self.restaurant_shift_id
      shift = restaurant.get_shift self.reservation_time
      correct_shift = (shift == self.restaurant_shift_id)
      if !correct_shift
        self.errors.add(:update, "Restaurant doest not have a shift during your reservation time")
        raise ActiveRecord::Rollback
      end
    end
    #time change
    if current_reservation.reservation_time != self.reservation_time
      reserved_tables = ReservedTable.joins(:restaurant_table)
                          .where(restaurant_id: restaurant.id)
                          .where(reservation_time: self.reservation_time - 3600...self.reservation_time + 3600)
                          .where(restaurant_table_id: self.restaurant_table_id)
                          .where.not(reservation_id: self.id)
      puts reserved_tables.to_json
      shift = restaurant.get_shift self.reservation_time
      correct_shift = (shift == self.restaurant_shift_id)
      if !reserved_tables.empty? || !correct_shift
        self.errors.add(:update, "The table is not available at the requested time")
        raise ActiveRecord::Rollback
      end

    end

  end

  def create_reserved_table

  end

end
