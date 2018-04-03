class ReservationMailer < ApplicationMailer
  layout 'mailer'
  default from: 'notifications@umai.com'

  def reservation_confirmed reservation
    @guest = reservation.guest
    @reservation = reservation
    @restaurant = reservation.restaurant
    email_with_name = %("#{@guest.name}" <#{@guest.email}>)
    mail(to: email_with_name, subject: "Reservation confirmed at #{@restaurant.name} ")
  end
end
