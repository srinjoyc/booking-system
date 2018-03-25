class CreateRestaurantShifts < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurant_shifts do |t|
      t.references :restaurant, foreign_key: true
      t.integer :start_time
      t.integer :end_time
      t.string :name

      t.timestamps
    end
  end
end
