require 'rails_helper'

RSpec.describe 'Merchant orders show page'do
  before :each do
    @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @paper = @print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 5)
    @pencil = @print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @user = User.create!(name: 'Billy Joel',
                        address: '123 Song St.',
                        city: 'Las Vegas',
                        state: 'NV',
                        zip: '12345',
                        email: 'billy_j@user.com',
                        password: '123',
                        role: 0)

    @order_1 = @user.orders.create!(name: 'Billy Joel', address: '1616 Bedford Ave', city: 'Hershey', state: 'PA', zip: 17033)
    @io1 = @order_1.item_orders.create!(item: @paper, price: @paper.price, quantity: 2)
    @io2 = @order_1.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 3)
    @io3 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 1)

    @merchant = User.create!(name: 'Joel Billy',
                            address: '125 Song St.',
                            city: 'Las Vegas',
                            state: 'NV',
                            zip: '12345',
                            email: 'merchant',
                            merchant_id: @print_shop.id,
                            password: '123',
                            role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  describe 'a merchant' do
    it 'can visit their order show page' do
      visit '/merchant/dashboard'

      within "#orders-#{@order_1.id}" do
        click_link "#{@order_1.id}"
      end

      expect(current_path).to eq("/merchant/orders/#{@order_1.id}")

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_xpath("//img['#{@paper.image}']")
        expect(page).to have_content(@paper.price)
        expect(page).to have_content(@io1.quantity)
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_xpath("//img['#{@pencil.image}']")
        expect(page).to have_content(@pencil.price)
        expect(page).to have_content(@io2.quantity)
      end

      expect(page).to_not have_content(@tire.name)
      expect(page).to_not have_content(@tire.name)
      expect(page).to_not have_content(@tire.price)
    end

    it 'can each items status and has a button to fulfill if item is unfulfilled' do
      visit "/merchant/orders/#{@order_1.id}"

      within "#item-#{@paper.id}" do
        expect(page).to have_content(@io1.order_status)
        expect(page).to have_button("Fulfill Order")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_content(@io2.order_status)
        expect(page).to have_button("Fulfill Order")
        click_button 'Fulfill Order'
      end

      expect(current_path).to eq("/merchant/orders/#{@order_1.id}")
      expect(page).to have_content("Item is now fulfilled")

      within "#item-#{@pencil.id}" do
        expect(page).to have_content("Item status: fulfilled")
        expect(page).to_not have_button("Fulfill Order")
      end
    end
  end
end
