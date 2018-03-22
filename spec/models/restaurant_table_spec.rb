require 'rails_helper'

RSpec.describe RestaurantTable, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:restaurant_table)).to be_valid
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :maximum_count }
    it { is_expected.to validate_presence_of :minimum_count }
    it { is_expected.to validate_presence_of :restaurant_id }
  end
end
