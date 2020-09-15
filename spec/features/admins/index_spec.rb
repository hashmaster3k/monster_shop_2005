require 'rails_helper'

RSpec.describe 'Admin dashboard' do
  before :each do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
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

    visit '/admin'
  end

  it 'can see all orders in the system with:
  - user who placed the order, (which links to admin view of user profile)
  - order id,
  - date the order was created' do

    expect(page).to have_link(@user.name)
    @orders.each do |order|
      expect(page).to have_content(order.id)
      expect(page).to have_content(order.created_at)
    end
    elements = all("#packaged-#{@order_3.id}, #pending-#{@order_1.id}, #pending-#{@order_5.id}, #shipped-#{@order_2.id}, #cancelled-#{@order_4.id}")
    expect(elements[0]['id']).to eql("packaged-#{@order_3.id}")
    expect(elements[1]['id']).to eql("pending-#{@order_1.id}")
    expect(elements[2]['id']).to eql("pending-#{@order_5.id}")
    expect(elements[3]['id']).to eql("shipped-#{@order_2.id}")
    expect(elements[4]['id']).to eql("cancelled-#{@order_4.id}")

    within "#packaged-#{@order_3.id}" do
      click_link "#{@user.name}"
      expect(current_path).to eq("/admin/users/#{@user.id}")
    end
  end

  it 'can see any packaged orders and a button to ship the order. The status changes to shipped when the ship button is clicked and the user can no longer cancel the order' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit "/profile/orders/#{@order_3.id}"
    expect(page).to have_button("Cancel Order")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit '/admin'

    within "#packaged-#{@order_3.id}" do
      expect(page).to have_content(@order_3.id)
      expect(page).to have_button("Ship This Order")
      click_button "Ship This Order"
    end

    expect(current_path).to eq('/admin')

    within "#shipped-#{@order_3.id}" do
      expect(page).to have_content(@order_3.id)
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit "/profile/orders/#{@order_3.id}"
    # save_and_open_page
    expect(page).to_not have_button("Cancel Order")
  end

end
