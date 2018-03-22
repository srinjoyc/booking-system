require 'rails_helper'

RSpec.describe Reservation, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:reservation)).to be_valid
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :guest_count }
    it { is_expected.to validate_presence_of :reservation_time }
    it { is_expected.to validate_presence_of :restaurant_id }
    it { is_expected.to validate_presence_of :restaurant_table_id }
    it { is_expected.to validate_presence_of :restaurant_shift_id }
  end
end
