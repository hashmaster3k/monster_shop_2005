require "rails_helper"

RSpec.describe "User Orders Show Page" do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @user = User.create!(name: 'Billy Joel',
      address: '123 Song St.',
      city: 'Las Vegas',
      state: 'NV',
      zip: '12345',
      email: 'billy_j@user.com',
      password: '123',
      role: 0)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 3)
    end

  it "I see every order I've made including the orders information" do
    visit "/login"

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password

    click_button "Log in"

    within ".topnav" do
      click_link "My Orders"
    end

    within "#order-#{@order_1.id}" do
      click_link("Order ##{@order_1.id}")
    end

    expect(current_path).to eq("/profile/orders/#{@order_1.id}")

    expect(page).to have_content("Order ##{@order_1.id}")
    within ".order_info" do
      expect(page).to have_content("Order Creation: #{@order_1.created_at.strftime("%m/%d/%y")}")
      expect(page).to have_content("Order Update: #{@order_1.updated_at.strftime("%m/%d/%y")}")
      expect(page).to have_content("Current Status: #{@order_1.order_status}")
      expect(page).to have_content("Total Quantity: #{@order_1.total_quantity}")
    end

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to have_content(@pull_toy.description)
      expect(page).to have_link("#{@pull_toy.merchant.name}")
      expect(page).to have_content("$#{@pull_toy.price}")
      expect(page).to have_content("3")
      expect(page).to have_content("$30")
    end

    within "#item-#{@tire.id}" do
      expect(page).to have_link(@tire.name)
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_content(@tire.description)
      expect(page).to have_link("#{@tire.merchant.name}")
      expect(page).to have_content("$#{@tire.price}")
      expect(page).to have_content("2")
      expect(page).to have_content("$200")
    end

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_link(@dog_bone.name)
      expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      expect(page).to have_content(@dog_bone.description)
      expect(page).to have_link("#{@dog_bone.merchant.name}")
      expect(page).to have_content("$#{@dog_bone.price}")
      expect(page).to have_content("3")
      expect(page).to have_content("$60")
    end
  end

  # User Story 29, User views an Order Show Page
  #
  # As a registered user
  # When I visit my Profile Orders page
  # And I click on a link for order's show page
  # My URL route is now something like "/profile/orders/15"
  # I see all information about the order, including the following information:
  # - the ID of the order
  # - the date the order was made
  # - the date the order was last updated
  # - the current status of the order

  # - each item I ordered description, thumbnail
  # - the total quantity of items in the whole order
  # - the grand total of all items for that order
end
