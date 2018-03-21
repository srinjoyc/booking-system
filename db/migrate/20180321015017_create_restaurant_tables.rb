class CreateRestaurantTables < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurant_tables do |t|
      t.references :restaurant, foreign_key: true
      t.integer :minimum_count
      t.integer :maximum_count
      t.string :name

      t.timestamps
    end
  end
end
