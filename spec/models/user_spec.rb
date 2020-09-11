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

  describe "instance methods" do
    it "#update_user_info" do
      user1 = User.create!(name: 'Billy Joel',
        address: '123 Song St.',
        city: 'Las Vegas',
        state: 'NV',
        zip: '12345',
        email: 'billy_j@user.com',
        password: '123',
        role: 0)

      user2 = User.create!(name: 'Bill J',
                          address: '123 Meledy St.',
                          city: 'Denver',
                          state: 'CO',
                          zip: '54321',
                          email: 'bill_j@user.com',
                          password: '321',
                          role: 0)

      user2.update_user_info({name: user2.name, address: user2.address, city: user2.city, state: user2.state, zip: user2.zip, email: "123456"})
      expect(user2.email).to eq("123456")

      expected = user2.update_user_info({name: user2.name, address: user2.address, city: user2.city, state: user2.state, zip: user2.zip, email: user1.email})
      expect(expected).to eq(false)
    end
  end
end
