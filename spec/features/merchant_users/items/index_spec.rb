require 'rails_helper'

RSpec.describe 'Merchant dashboard items index' do
  before :each do
    @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @paper = @print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @merchant = User.create!(name: 'Joel Billy',
      address: '125 Song St.',
      city: 'Las Vegas',
      state: 'NV',
      zip: '12345',
      email: 'merchant',
      merchant_id: @print_shop.id,
      password: '123',
      role: 1)

    visit '/login'

    fill_in :email, with: @merchant.email
    fill_in :password, with: @merchant.password

    click_button 'Log in'

    visit "/merchant"
  end

  it "I should see a link to view my own items" do
    expect(page).to have_link("Items")
    click_link "Items"

    expect(current_path).to eq("/merchant/items")
  end
end
