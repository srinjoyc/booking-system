require "faker"
FactoryGirl.define do

  factory :guest do
    name Faker::Name.name
    email Faker::Internet.email
  end

  factory :restaurant do
    name Faker::Name.name
    email Faker::Internet.email
    phone_number Faker::PhoneNumber.phone_number
  end

  factory :restaurant_table do
    maximum_count Faker::Number.between(3, 10)
    minimum_count Faker::Number.between(1,2)
    restaurant { Restaurant.first || association(:restaurant) }
  end

  factory :restaurant_shift do
    name Faker::Name.name
    start_time Faker::Time.between(2.days.ago, Date.today, :morning)
    end_time Faker::Time.between(2.days.ago, Date.today, :night)
    restaurant { Restaurant.first || association(:restaurant) }
  end

  factory :reservation do
    guest_count Faker::Number.between(1, 100)
    reservation_time Faker::Time.forward(2, :morning)
    restaurant { Restaurant.first || association(:restaurant) }
    guest { Guest.first || association(:guest) }
    restaurant_table { RestaurantTable.first || association(:restaurant_table) }
    restaurant_shift { RestaurantShift.first || association(:restaurant_shift) }
  end
end
