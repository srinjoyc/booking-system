class Guest < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: { with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }
end
