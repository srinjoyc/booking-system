require 'test_helper'

class RestaurantTablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant_table = restaurant_tables(:one)
  end

  test "should get index" do
    get restaurant_tables_url, as: :json
    assert_response :success
  end

  test "should create restaurant_table" do
    assert_difference('RestaurantTable.count') do
      post restaurant_tables_url, params: { restaurant_table: { maximum_count: @restaurant_table.maximum_count, minimum_count: @restaurant_table.minimum_count, name: @restaurant_table.name, restaurant_id: @restaurant_table.restaurant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show restaurant_table" do
    get restaurant_table_url(@restaurant_table), as: :json
    assert_response :success
  end

  test "should update restaurant_table" do
    patch restaurant_table_url(@restaurant_table), params: { restaurant_table: { maximum_count: @restaurant_table.maximum_count, minimum_count: @restaurant_table.minimum_count, name: @restaurant_table.name, restaurant_id: @restaurant_table.restaurant_id } }, as: :json
    assert_response 200
  end

  test "should destroy restaurant_table" do
    assert_difference('RestaurantTable.count', -1) do
      delete restaurant_table_url(@restaurant_table), as: :json
    end

    assert_response 204
  end
end
