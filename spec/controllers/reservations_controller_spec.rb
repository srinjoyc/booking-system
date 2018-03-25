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
    end

    context 'no conflicts for the reservation' do
      it 'creates a reservation at the restaurant.' do
        expect(Restaurant.count).to eq(1)
      end
    end

    # context 'user not in db - invalid id' do
    #   it 'returns a not found error' do
    #     get :show, params: {:id => "1000"}
    #     resp = json(response)
    #     puts resp
    #     expect(resp.key?('error')).to eq(true)
    #     expect(resp['error']).to eq("Couldn\'t find Guest with 'id'=1000")
    #   end
    # end

  end

end

private
  def json response
    JSON.parse response.body
  end
