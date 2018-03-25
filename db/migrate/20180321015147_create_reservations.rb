class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.references :restaurant, foreign_key: true
      t.references :guest, foreign_key: true
      t.references :restaurant_table, foreign_key: true
      t.references :restaurant_shift, foreign_key: true
      t.integer :guest_count
      t.integer :reservation_time

      t.timestamps
    end
  end
end
