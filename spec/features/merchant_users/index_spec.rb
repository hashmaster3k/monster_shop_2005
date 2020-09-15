require 'rails_helper'

RSpec.describe 'Merchant dashboard' do
  before :each do
    @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @merchant = User.create!(name: 'Joel Billy',
      address: '125 Song St.',
      city: 'Las Vegas',
      state: 'NV',
      zip: '12345',
      email: 'merchant',
      merchant_id: @print_shop.id,
      password: '123',
      role: 1)


    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    visit '/login'

    fill_in :email, with: @merchant.email
    fill_in :password, with: @merchant.password

    click_button 'Log in'
  end

  it "When I visit my dashboard, I see the name and full address of the merchant I work for" do
    visit "/merchant"

    expect(page).to have_content(@print_shop.name)
    expect(page).to have_content(@print_shop.address)
    expect(page).to have_content(@print_shop.city)
    expect(page).to have_content(@print_shop.state)
    expect(page).to have_content(@print_shop.zip)
  end
end
