require 'rails_helper'

RSpec.describe 'admin users index page' do
  before :each do

    @user_1 = User.create!(name: 'Billy Joel',
                          address: '123 Song St.',
                          city: 'Las Vegas',
                          state: 'NV',
                          zip: '12345',
                          email: 'billy_j@user.com',
                          password: '123',
                          role: 0)

    @user_2 = User.create!(name: 'Chilly Billy',
                          address: '123 Song St.',
                          city: 'Las Vegas',
                          state: 'NV',
                          zip: '12345',
                          email: 'chilly_b@user.com',
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
    it 'can visit admin/users and see all users in system' do
      visit '/admin/users'

      within "#user-#{@user_1.id}" do
        expect(page).to have_link(@user_1.name)
        expect(page).to have_content(@user_1.created_at)
        expect(page).to have_content(@user_1.role)
      end

      within "#user-#{@user_2.id}" do
        expect(page).to have_link(@user_2.name)
        expect(page).to have_content(@user_2.created_at)
        expect(page).to have_content(@user_2.role)
        click_link @user_2.name
      end

      expect(current_path).to eq("/admin/users/#{@user_2.id}")
    end
  end

end
