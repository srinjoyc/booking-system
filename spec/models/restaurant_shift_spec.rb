require 'rails_helper'

RSpec.describe RestaurantShift, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:restaurant_shift)).to be_valid
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :start_time }
    it { is_expected.to validate_presence_of :end_time }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :restaurant_id }
  end
end
