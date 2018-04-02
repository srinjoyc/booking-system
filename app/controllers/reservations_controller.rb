class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :update, :destroy]
  before_action :verify_guest, only: [:create, :update]
  # GET /reservations
  def index
    @reservations = Reservation.all

    render json: @reservations
  end

  # GET /reservations/1
  def show
    render json: @reservation
  end

  #POST /mobile-reservations
  def mobile_create
    #:restaurant_id, :restaurant_table,
    #:restaurant_shift,:reservation_time,
    #:guest_id, :guest_count
    request = mobile_create_params
    restaurant = Restaurant.find(request[:restaurant_id])
    reserved_table_ids = Reservation.get_reserved_tables request[:restaurant_id], request[:reservation_time].to_time
    if reserved_table_ids.to_json.include?(request[:restaurant_table_id])
      table = nil
    else
      table = RestaurantTable.find(request[:restaurant_table_id])
      if !table.check_guest_count request[:guest_count].to_i
        render json: table.errors, status: :unprocessable_entity
        return
      end
    end

    if table.nil?
      render json: {restaurant: 'does not have that table at that time'}, status: :unprocessable_entity
      return
    end

    shift = restaurant.get_shift request[:reservation_time].to_time
    if shift.nil?
      render json: {error:restaurant.errors, restaurant: RestaurantShift.restaurant_shift_string(request[:restaurant_id])}, status: :unprocessable_entity
      return
    end

    @reservation = Reservation.new({
        restaurant_id: request[:restaurant_id],
        guest_id: request[:guest_id],
        restaurant_table_id: table.id,
        restaurant_shift_id: shift.id,
        guest_count: request[:guest_count],
        reservation_time: request[:reservation_time].to_time
      })
      if @reservation.save
        Reservation.reserve_table @reservation, table
        render json: @reservation, status: :created, location: @reservation
      else
        render json: @reservation.errors, status: :unprocessable_entity
      end
  end
  # POST /reservations
  def create
    #santatize params
    request = create_reservation_params

    restaurant = Restaurant.find(request[:restaurant_id])
    puts request[:reservation_time].to_time.in_time_zone('Eastern Time (US & Canada)')
    table = Reservation.get_table(restaurant.id, request[:reservation_time].in_time_zone('Eastern Time (US & Canada)'), request[:guest_count])
    shift = restaurant.get_shift request[:reservation_time].to_time
    if table.nil? || shift.nil?
      msg = ""
      msg += "has no tables available at that time" if table.nil?
      msg += "is not open at that time. #{RestaurantShift.restaurant_shift_string restaurant.id}" if shift.nil?
      error = {
        restaurant: msg
      }
      render json: error, status: :unprocessable_entity
      return
    end

    @reservation = Reservation.new({
        restaurant_id: restaurant.id,
        guest_id: @guest.id,
        restaurant_table_id: table.id,
        restaurant_shift_id: shift.id,
        guest_count: request[:guest_count],
        reservation_time: request[:reservation_time].to_time
      })

    if @reservation.save
      Reservation.reserve_table @reservation, table
      render json: @reservation, status: :created, location: @reservation
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reservations/1
  def update
    if @reservation.update(reservation_params)
      render json: @reservation
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reservations/1
  def destroy
    @reservation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:restaurant_id, :guest_id, :restaurant_table_id, :restaurant_shift_id, :guest_count, :reservation_time, :guest_email)
    end

    def create_reservation_params
      params.require(:reservation).permit(:restaurant_id, :guest_email, :guest_count,:reservation_time)
    end

    def mobile_create_params
      params.require(:reservation).permit(:restaurant_id, :restaurant_table_id, :restaurant_shift_id,:reservation_time, :guest_id, :guest_count)
    end

    def verify_guest
      @guest = Guest.find_by_email(params[:reservation][:guest_email])
      if @guest.nil?
        error = {
          guest: 'is not registered. Please create an account first.'
        }
        render json: error, status: :unauthorized
      end
      return
    end
end
