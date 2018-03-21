class RestaurantShiftsController < ApplicationController
  before_action :set_restaurant_shift, only: [:show, :update, :destroy]

  # GET /restaurant_shifts
  def index
    @restaurant_shifts = RestaurantShift.all

    render json: @restaurant_shifts
  end

  # GET /restaurant_shifts/1
  def show
    render json: @restaurant_shift
  end

  # POST /restaurant_shifts
  def create
    @restaurant_shift = RestaurantShift.new(restaurant_shift_params)

    if @restaurant_shift.save
      render json: @restaurant_shift, status: :created, location: @restaurant_shift
    else
      render json: @restaurant_shift.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /restaurant_shifts/1
  def update
    if @restaurant_shift.update(restaurant_shift_params)
      render json: @restaurant_shift
    else
      render json: @restaurant_shift.errors, status: :unprocessable_entity
    end
  end

  # DELETE /restaurant_shifts/1
  def destroy
    @restaurant_shift.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant_shift
      @restaurant_shift = RestaurantShift.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def restaurant_shift_params
      params.require(:restaurant_shift).permit(:restaurant_id, :start_time, :end_time, :name)
    end
end
