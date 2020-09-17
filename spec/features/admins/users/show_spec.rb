require 'rails_helper'

RSpec.describe 'admin users show page' do
  before :each do

    @user = User.create!(name: 'Billy Joel',
                          address: '123 Song St.',
                          city: 'Las Vegas',
                          state: 'NV',
                          zip: '12345',
                          email: 'billy_j@user.com',
                          password: '123',
                          role: 0)

    @admin = User.create!(name: 'Chilly Billy',
                        address: '125 Song St.',
                        city: 'Las Vegas',
                        state: 'NV',
                        zip: '12345',
                        email: 'chilly_b@admin.com',
                        password: '123',
                        role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'an admin' do
    it 'can visit a users profile page' do
      visit "/admin/users/#{@user.id}"

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)

      expect(page).to_not have_link("Edit Profile Information")
    end
  end

end
