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

    @user = User.create!(name: 'Billy Joel',
                          address: '123 Song St.',
                          city: 'Las Vegas',
                          state: 'NV',
                          zip: '12345',
                          email: 'billy_j@user.com',
                          password: '123',
                          role: 0)


    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)


    @order_1 = @user.orders.create!(name: 'Dude', address: '123 Stang Ave', city: 'Ft. Collins', state: 'CO', zip: 17033)
    @order_2 = @user.orders.create!(name: 'Meg', address: '321 Not Stang Ave', city: 'Hershey', state: 'PA', zip: 12345)
    @order_3 = @user.orders.create!(name: 'Napoleon', address: '678 Desert Dr.', city: 'Scottsdale', state: 'AZ', zip: 54321)

    #order 1
    ItemOrder.create!(order_id: @order_1.id, item_id: @pencil.id, quantity: 2, price: @pencil.price)
    ItemOrder.create!(order_id: @order_1.id, item_id: @paper.id, quantity: 1, price: @paper.price)
    #order 2
    ItemOrder.create!(order_id: @order_2.id, item_id: @paper.id, quantity: 1, price: @paper.price)

    visit '/login'

    fill_in :email, with: @merchant.email
    fill_in :password, with: @merchant.password

    click_button 'Log in'

    visit "/merchant"
  end

  it "When I visit my dashboard, I see the name and full address of the merchant I work for" do
    expect(page).to have_content(@print_shop.name)
    expect(page).to have_content(@print_shop.address)
    expect(page).to have_content(@print_shop.city)
    expect(page).to have_content(@print_shop.state)
    expect(page).to have_content(@print_shop.zip)
  end

  it "I see a list of pending orders containing items I sell. Orders have ID that is link, order creation, total quatity, total value." do
    within "#orders-#{@order_1.id}" do
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content("2")
      expect(page).to have_content("24")
    end

    within "#orders-#{@order_2.id}" do
      expect(page).to have_content(@order_2.id)
      expect(page).to have_content(@order_2.created_at)
      expect(page).to have_content("1")
      expect(page).to have_content("20")
    end
  end
end
