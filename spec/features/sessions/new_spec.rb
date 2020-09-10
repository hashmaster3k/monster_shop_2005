require 'rails_helper'

RSpec.describe 'NEW SESSION' do
  before :each do
    @user = User.create!(name: 'Billy Joel',
                        address: '123 Song St.',
                        city: 'Las Vegas',
                        state: 'NV',
                        zip: '12345',
                        email: 'billy_j@user.com',
                        password: '123',
                        role: 0)

    @merchant = User.create!(name: 'Joel Billy',
                            address: '125 Song St.',
                            city: 'Las Vegas',
                            state: 'NV',
                            zip: '12345',
                            email: 'billy_j@merchant.com',
                            password: '123',
                            role: 1)

    @admin = User.create!(name: 'Chilly Billy',
                          address: '125 Song St.',
                          city: 'Las Vegas',
                          state: 'NV',
                          zip: '12345',
                          email: 'chilly_b@admin.com',
                          password: '123',
                          role: 2)
  end

  describe 'a user' do
    it 'can log in and see their profile page' do
      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button 'Log in'

      expect(current_path).to eq('/profile')
      expect(page).to have_content("Logged in as #{@user.name}")

      within '.topnav' do
        expect(page).to have_link('Log out')
        expect(page).to_not have_link('Log in')
      end
    end
  end

  describe 'edge casing' do
    it 'has to have a valid email' do
      visit '/login'

      fill_in :email, with: "bily_j@user.com"
      fill_in :password, with: @user.password

      click_button 'Log in'

      expect(page).to have_content("Credentials are incorrect")
    end

    it 'must have a valid password' do
      visit 'login'

      fill_in :email, with: @user.email
      fill_in :password, with: 122

      click_button 'Log in'

      expect(page).to have_content("Credentials are incorrect")
    end
  end

  describe 'as a merchant' do
    it 'i can log in and see my dashboard' do
      visit '/login'

      fill_in :email, with: @merchant.email
      fill_in :password, with: @merchant.password

      click_button 'Log in'

      expect(current_path).to eq('/merchant/dashboard')
      expect(page).to have_content("Logged in as #{@merchant.name}")
    end
  end

  describe 'as a admin' do
    it 'i can log in and see my dashboard' do
      visit '/login'

      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password

      click_button 'Log in'

      expect(current_path).to eq('/admin/dashboard')
      expect(page).to have_content("Logged in as #{@admin.name}")
    end
  end
end
