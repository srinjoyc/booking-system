class ReservedTables < ActiveRecord::Migration[5.1]
  def change
    create_table :reserved_tables do |t|
      t.references :restaurant, foreign_key: true
      t.references :restaurant_table, foreign_key: true
      t.references :reservation, foreign_key: true
      t.datetime :reservation_time
      t.timestamps
    end
  end
end
