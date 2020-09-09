require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :address}
    it { should validate_presence_of :city}
    it { should validate_presence_of :state}
    it { should validate_presence_of :zip}
    it { should validate_presence_of :email}
    it { should validate_uniqueness_of :email}
    it { should validate_presence_of :password}
  end
  it 'can create a user' do
    User.create!(name: "Billy Joel",
                address: "1234 Hi Way",
                city: "Golden",
                state: "CO",
                zip: "33574",
                email: "billy_j@user.com",
                password: "Iamthebest"
                )
    expect(User.count).to eq(1)
  end
end
