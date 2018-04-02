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
          reservation_time: "Wed, 11 Jul 2012 8:10:00"
        })
    end

    context 'all details are valid and no conflicting reservations during creation' do
      it 'creates a reservation at the restaurant.' do
        params = {
          reservation: {
            restaurant_id: @restaurant.id,
            restaurant_table_id: @table.id,
            restaurant_shift_id: @shift.id,
            guest_id: @guest.id,
            guest_count: 4,
            reservation_time: "Wed, 11 Jul 2012 9:10:00"
          }
        }
        post :mobile_create, params: params
        expect(Reservation.count).to eq(2)
      end
    end

    context 'there are existing conflicts or invalid fields during creation' do
      it 'gives an error if there is a conflicting reservation' do
        params = {
          reservation: {
            restaurant_id: @restaurant.id,
            restaurant_table_id: @table.id,
            restaurant_shift_id: @shift.id,
            guest_id: @guest.id,
            guest_count: 4,
            reservation_time: "Wed, 11 Jul 2012 8:30:00" # same time as existing resevation
          }
        }
        post :mobile_create, params: params
        resp = json(response)
        expect(resp.key?('error')).to eq(true)
        expect(Reservation.count).to eq(1)
      end
      it 'gives an error if the reservation time is not during any of a restaurants shift' do
        params = {
          reservation: {
            restaurant_id: @restaurant.id,
            restaurant_table_id: @table.id,
            restaurant_shift_id: @shift.id,
            guest_id: @guest.id,
            guest_count: 4,
            reservation_time: "Wed, 11 Jul 2012 14:30:00" # same time as existing resevation
          }
        }
        post :mobile_create, params: params
        resp = json(response)
        expect(resp.key?('error')).to eq(true)
        expect(Reservation.count).to eq(1)
      end

      it 'gives an error if the guest count is above the maximum for the table' do
        params = {
          reservation: {
            restaurant_id: @restaurant.id,
            restaurant_table_id: @table.id,
            restaurant_shift_id: @shift.id,
            guest_id: @guest.id,
            guest_count: 8,
            reservation_time: "Wed, 11 Jul 2012 9:10:00" # same time as existing resevation
          }
        }
        post :mobile_create, params: params
        resp = json(response)
        expect(Reservation.count).to eq(1)
      end

      it 'gives an error if the guest count is below the minimum for the table' do
        params = {
          reservation: {
            restaurant_id: @restaurant.id,
            restaurant_table_id: @table.id,
            restaurant_shift_id: @shift.id,
            guest_id: @guest.id,
            guest_count: 1,
            reservation_time: "Wed, 11 Jul 2012 9:10:00" # same time as existing resevation
          }
        }
        post :mobile_create, params: params
        resp = json(response)
        expect(Reservation.count).to eq(1)
      end

      it 'gives an error if any of the ids do not exist' do
        params = {
          reservation: {
            restaurant_id: @restaurant.id,
            restaurant_table_id: @table.id,
            restaurant_shift_id: @shift.id,
            guest_id: 100,
            guest_count: 1,
            reservation_time: "Wed, 11 Jul 2012 9:10:00" # same time as existing resevation
          }
        }
        post :mobile_create, params: params
        resp = json(response)
        expect(Reservation.count).to eq(1)
      end

    end

  end

end

private
  def json response
    JSON.parse response.body
  end
