class Restaurant < ApplicationRecord
  has_many :restaurant_tables, :dependent => :destroy
  has_many :restaurant_shifts, :dependent => :destroy
  has_many :reservations, :dependent => :destroy
  validates :name, :email, :phone_number, presence: true
  validates :email, uniqueness: true,
    format: { with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }

    def get_shift time
      hour = time.hour
      shift = self.restaurant_shifts.where("start_time <= ? AND end_time >= ?", hour, hour + 1).first
    end
    #Wed, 11 Jul 2012 08:30:00 GMT +00:00, res_id: 8
end
