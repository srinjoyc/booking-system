require 'rails_helper'
RSpec.describe ReservationsController, type: :controller do


  # SHOW
  describe 'Create a reservation' do
    # Sample guest already in database
    before :example do
      @guest = Guest.create!({
        name: 'Srinjoy',
        email: 'srinjoy@live.ca'
      })
      @restaurant = Restaurant.create!({
        name: 'Food Palace',
        email: 'owner@live.ca',
        phone_number: '444-444-4444'
      })
      @table = RestaurantTable.create!({
        name: 'Booth 3',
        restaurant_id: @restaurant.id,
        minimum_count: 3,
        maximum_count: 5
      })
      @shift = RestaurantShift.create!({
        name: 'Morning',
        restaurant_id: @restaurant.id,
        start_time: 9,
        end_time: 13
      })
      @reservation = Reservation.create!({
          restaurant_id: @restaurant.id,
          restaurant_table_id: @table.id,
          restaurant_shift_id: @shift.id,
          guest_id: @guest.id,
          guest_count: 4,
          reservation_time: 9
        })
    end

    context 'all details are valid and no conflicting reservations' do
      it 'creates a reservation at the restaurant.' do
        params = {
          reservation: {
            restaurant_id: @restaurant.id,
            restaurant_table_id: @table.id,
            restaurant_shift_id: @shift.id,
            guest_id: @guest.id,
            guest_count: 4,
            reservation_time: 7
          }
        }
        post :create, params: params
        expect(Reservation.count).to eq(2)
      end
    end

    context 'there are existing conflicts or invalid fields' do
      it 'gives an error if there is a conflicting reservation' do
        params = {
          reservation: {
            restaurant_id: @restaurant.id,
            restaurant_table_id: @table.id,
            restaurant_shift_id: @shift.id,
            guest_id: @guest.id,
            guest_count: 4,
            reservation_time: 5
          }
        }
        post :create, params: params
        expect(Reservation.count).to eq(1)
      end
    end

  end

end

private
  def json response
    JSON.parse response.body
  end
