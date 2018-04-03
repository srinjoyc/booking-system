class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :update, :destroy]
  before_action :verify_guest, only: :create
  # GET /reservations
  def index
    @reservations = Reservation.all
    render json: @reservations
  end

  # GET reservations/restaurant/:id
  def restaurants
    restaurant = Restaurant.find(params[:id])
    restaurant_reservations = Reservation.joins(:guest, :restaurant_table)
                                .select("reservation_time,
                                         guest_count,
                                         guests.name as guest_name,
                                         restaurant_tables.name as table_name")
    render json: restaurant_reservations.to_json
  end

  # GET /reservations/1
  def show
    render json: @reservation
  end

  #POST /mobile-reservations
  def mobile_create

    request = mobile_create_params
    restaurant = Restaurant.find(request[:restaurant_id])
    guest = Guest.find(request[:guest_id])
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
        guest_id: guest.id,
        restaurant_table_id: table.id,
        restaurant_shift_id: shift.id,
        guest_count: request[:guest_count],
        reservation_time: request[:reservation_time].to_time
      })
      if @reservation.save
        Reservation.reserve_table @reservation, table
        ReservationMailer.reservation_confirmed(@reservation).deliver_later
        render json: @reservation, status: :created, location: @reservation
      else
        render json: @reservation.errors, status: :unprocessable_entity
      end
  end
  # POST /reservations
  def create
    # @guest initialized below in verify_guest
    request = create_reservation_params
    restaurant = Restaurant.find(request[:restaurant_id])
    table = Reservation.get_table request[:restaurant_id], request[:reservation_time].to_time, request[:guest_count]
    puts table.to_json
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
        guest_id: @guest.id,
        restaurant_table_id: table.id,
        restaurant_shift_id: shift.id,
        guest_count: request[:guest_count],
        reservation_time: request[:reservation_time].to_time
      })
    if @reservation.save
      Reservation.reserve_table @reservation, table
      ReservationMailer.reservation_confirmed(@reservation).deliver_later
      render json: @reservation, status: :created, location: @reservation
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /reservations/1
  def update
    request = update_reservation_params
    if @reservation.update(request)
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

    def update_reservation_params
      params.require(:reservation).permit(:guest_count,:reservation_time,:restaurant_table_id, :restaurant_shift_id)
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
