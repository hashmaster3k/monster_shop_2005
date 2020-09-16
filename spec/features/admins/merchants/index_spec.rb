require 'rails_helper'

RSpec.describe 'Admins merchant index page' do
  before :each do
  @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
  @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203, status: "disabled")
  @admin = User.create!(name: 'Chilly Billy',
                        address: '125 Song St.',
                        city: 'Las Vegas',
                        state: 'NV',
                        zip: '12345',
                        email: 'chilly_b@admin.com',
                        password: '123',
                        role: 2)
    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_button 'Log in'
  end

  it "can see a disable button next to any merchants who are not yet disabled" do
    visit '/admin/merchants'

    expect(page).to have_button("disable")

    within "#merchant-#{@print_shop.id}" do
      expect(page).to have_content("enabled")
      click_button "disable"
    end

    expect(current_path).to eq("/admin/merchants")
    expect(page).to have_content("#{@print_shop.name} is now disabled")

    within "#merchant-#{@print_shop.id}" do
      expect(page).to_not have_button("disable")
      expect(page).to have_content("disabled")
    end
  end

  it "can see an enable button next to any merchants who are disabled" do
    visit '/admin/merchants'

    expect(page).to have_button("enable")

    within "#merchant-#{@bike_shop.id}" do
      expect(page).to have_content("disabled")
      click_button "enable"
    end

    expect(current_path).to eq("/admin/merchants")
    expect(page).to have_content("#{@bike_shop.name} is now enabled")

    within "#merchant-#{@bike_shop.id}" do
      expect(page).to_not have_button("enable")
      expect(page).to have_content("enabled")
    end
  end
end
# As an admin
# When I visit the admin's merchant index page ('/admin/merchants')
# I see a "disable" button next to any merchants who are not yet disabled
# When I click on the "disable" button
# I am returned to the admin's merchant index page where I see that the merchant's account is now disabled
# And I see a flash message that the merchant's account is now disabled
