class RestaurantTablesController < ApplicationController
  before_action :set_restaurant_table, only: [:show, :update, :destroy]

  # GET /restaurant_tables
  def index
    @restaurant_tables = RestaurantTable.all

    render json: @restaurant_tables
  end

  # GET /restaurant_tables/1
  def show
    render json: @restaurant_table
  end

  # POST /restaurant_tables
  def create
    @restaurant_table = RestaurantTable.new(restaurant_table_params)

    if @restaurant_table.save
      render json: @restaurant_table, status: :created, location: @restaurant_table
    else
      render json: @restaurant_table.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /restaurant_tables/1
  def update
    if @restaurant_table.update(restaurant_table_params)
      render json: @restaurant_table
    else
      render json: @restaurant_table.errors, status: :unprocessable_entity
    end
  end

  # DELETE /restaurant_tables/1
  def destroy
    @restaurant_table.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant_table
      @restaurant_table = RestaurantTable.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def restaurant_table_params
      params.require(:restaurant_table).permit(:restaurant_id, :minimum_count, :maximum_count, :name)
    end
end
