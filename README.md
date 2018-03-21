#Guest
attributes:
  - name (req)
  - email (req)
checks:
  - not null
  - valid email regex
#Restaurant
attributes:
  - name (req)
  - email (req)
  - phone (req)
checks:
  - not null
  - valid email regex
  - valid phone number regex
#Shifts
attributes:
  - start-time (req)
  - end-time   (req)
  - Restaurant_id (req)
checks:
  - not null
  - start-time < end-time
#Tables
attributes:
  - name (req)
  - Minimum (req)
  - Maximum (req)
  - Restaurant_id (req)
checks:
  - not null
  - Min > 0
#Reservations
  - Restaurant_id (req)
  - Guest_id (req)
  - Table_id (req)
  - shift_id (req)
  - guest_count (req)
  - reservation_time (req)
checks:
  - not null
  - table.Minimum < guest_count <= table.Maximum
  - Restaurant.shift.start-time < reservation_time < Restaurant.shift.end-time
  - No other reservations at this time for this table at this Restaurant

#API Endpoint 1 - Create a reservation.
    - Send email with reservation details to guest
    - Send email to Restaurant with guest details

#API Endpoint 2 - Update a reservation.
    - Send email with reservation details to guest with old and new times

#API Endpoint 3 - Get all Restaurant reservations.
    - List of all reservations of a Restaurant
    - Formatted to reservation time, guest count, guest name, table name
