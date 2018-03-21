require 'test_helper'

class RestaurantShiftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant_shift = restaurant_shifts(:one)
  end

  test "should get index" do
    get restaurant_shifts_url, as: :json
    assert_response :success
  end

  test "should create restaurant_shift" do
    assert_difference('RestaurantShift.count') do
      post restaurant_shifts_url, params: { restaurant_shift: { end_time: @restaurant_shift.end_time, name: @restaurant_shift.name, restaurant_id: @restaurant_shift.restaurant_id, start_time: @restaurant_shift.start_time } }, as: :json
    end

    assert_response 201
  end

  test "should show restaurant_shift" do
    get restaurant_shift_url(@restaurant_shift), as: :json
    assert_response :success
  end

  test "should update restaurant_shift" do
    patch restaurant_shift_url(@restaurant_shift), params: { restaurant_shift: { end_time: @restaurant_shift.end_time, name: @restaurant_shift.name, restaurant_id: @restaurant_shift.restaurant_id, start_time: @restaurant_shift.start_time } }, as: :json
    assert_response 200
  end

  test "should destroy restaurant_shift" do
    assert_difference('RestaurantShift.count', -1) do
      delete restaurant_shift_url(@restaurant_shift), as: :json
    end

    assert_response 204
  end
end
