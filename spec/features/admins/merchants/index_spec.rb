require 'rails_helper'

RSpec.describe 'Admin dashboard' do
  before :each do
    @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

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

    @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'CO', zip: 17033)
    @order_2 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, order_status: "shipped")
    @order_3 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'AZ', zip: 17033, order_status: "packaged")
    @order_4 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'DT', zip: 17033, order_status: "cancelled")
    @order_5 = @user.orders.create!(name: 'Ty', address: '123 Stang Ave', city: 'Hershey', state: 'MI', zip: 17033)

    @orders = Order.all

    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_button 'Log in'
  end

  it "I visit merchants index page with merchant names as links to thier respective show pages." do
    visit "/merchants"

    expect(page).to have_link(@print_shop.name)
    expect(page).to have_link(@bike_shop.name)

    click_link @print_shop.name

    expect(current_path).to eq("/admin/merchants/#{@print_shop.id}")
  end
end
