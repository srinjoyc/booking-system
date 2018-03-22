require 'rails_helper'

RSpec.describe Guest, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:guest)).to be_valid
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to validate_presence_of :name }
  end
end
