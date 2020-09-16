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

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12, active?: false)
    @paper = @print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

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

  it "I click on the disable button for an enabled merchant, then all of that merchants items should be deactivated" do
    visit '/admin/merchants'

    within "#merchant-#{@print_shop.id}" do
      click_button "disable"
    end

    visit "/items"

    expect(page).to_not have_content(@paper.name)
    expect(page).to_not have_content(@pencil.name)
  end

  it "I click on the disable button for an enabled merchant, then all of that merchants items should be deactivated" do
    visit '/items'

    expect(page).to_not have_content(@tire.name)

    visit '/admin/merchants'

    within "#merchant-#{@bike_shop.id}" do
      click_button "enable"
    end

    visit "/items"

    expect(page).to have_content(@tire.name)
  end
end
