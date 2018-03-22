class CreateRestaurantShifts < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurant_shifts do |t|
      t.references :restaurant, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.string :name

      t.timestamps
    end
  end
end
