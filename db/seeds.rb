# Guests

  guest_one = Guest.create({
      name: 'Srinjoy Chakraborty',
      email: 'srinjoycal@gmail.com'
    })

# Restaurants & Tables & Shifts

  restaurant_one = Restaurant.create({
      name: 'Noodle Box',
      email: 'noodles@noodle.com',
      phone_number: '405-495-0000'
    })
  table_one = RestaurantTable.create({
      name: 'Big table',
      restaurant_id: restaurant_one.id,
      minimum_count: 3,
      maximum_count: 10
    })
  table_two = RestaurantTable.create({
      name: 'Small table',
      restaurant_id: restaurant_one.id,
      minimum_count: 1,
      maximum_count: 3
    })
  shift_one = RestaurantShift.create({
      restaurant_id: restaurant_one.id,
      start_time: 8,
      end_time: 12,
      name: "Morning Shift"
    })

  restaurant_two = Restaurant.create({
      name: 'Steakhouse',
      email: 'sauce@steak.com',
      phone_number: '405-495-1111'
    })
    table_three = RestaurantTable.create({
        name: 'Big table',
        restaurant_id: restaurant_two.id,
        minimum_count: 3,
        maximum_count: 10
      })

    table_four = RestaurantTable.create({
        name: 'Small table',
        restaurant_id: restaurant_two.id,
        minimum_count: 9,
        maximum_count: 3
      })
    shift_two = RestaurantShift.create({
        restaurant_id: restaurant_two.id,
        start_time: 12,
        end_time: 16,
        name: "Evening Shift"
      })

  restaurant_three = Restaurant.create({
      name: 'Chicken House',
      email: 'chicken@house.com',
      phone_number: '405-495-1111'
    })
  table_five = RestaurantTable.create({
      name: 'Big table',
      restaurant_id: restaurant_three.id,
      minimum_count: 3,
      maximum_count: 10
    })

  table_six = RestaurantTable.create({
      name: 'Small table',
      restaurant_id: restaurant_three.id,
      minimum_count: 1,
      maximum_count: 3
    })
  shift_three = RestaurantShift.create({
      restaurant_id: restaurant_two.id,
      start_time: 16,
      end_time: 24,
      name: "All Day"
    })

  reservation_time = "31.03.2018 12:30 -0700".to_time
  puts  reservation_time
  reservation_one = Reservation.create({
      restaurant_id: restaurant_one.id,
      guest_id: guest_one.id,
      restaurant_table_id: table_one.id,
      restaurant_shift_id: shift_one.id,
      guest_count: 3,
      reservation_time: reservation_time
  })

  reserved_table = ReservedTable.create({
      restaurant_id: restaurant_one.id,
      restaurant_table_id: table_one.id,
      reservation_id: reservation_one.id,
      reservation_time: reservation_time
    })


  # create_table "reservations", force: :cascade do |t|
  #   t.bigint "restaurant_id"
  #   t.bigint "guest_id"
  #   t.bigint "restaurant_table_id"
  #   t.bigint "restaurant_shift_id"
  #   t.integer "guest_count"
  #   t.integer "reservation_time"
  #   t.datetime "created_at", null: false
  #   t.datetime "updated_at", null: false
  #   t.index ["guest_id"], name: "index_reservations_on_guest_id"
  #   t.index ["restaurant_id"], name: "index_reservations_on_restaurant_id"
  #   t.index ["restaurant_shift_id"], name: "index_reservations_on_restaurant_shift_id"
  #   t.index ["restaurant_table_id"], name: "index_reservations_on_restaurant_table_id"
  # end
