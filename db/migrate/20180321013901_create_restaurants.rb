class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end