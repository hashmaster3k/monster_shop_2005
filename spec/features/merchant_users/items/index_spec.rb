require 'rails_helper'

RSpec.describe 'Merchant dashboard items index' do
  before :each do
    @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

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

    @merchant = User.create!(name: 'Joel Billy',
      address: '125 Song St.',
      city: 'Las Vegas',
      state: 'NV',
      zip: '12345',
      email: 'merchant',
      merchant_id: @print_shop.id,
      password: '123',
      role: 1)

    @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'CO', zip: 17033)

    ItemOrder.create(item_id: @paper.id , order_id: @order_1.id, price: @paper.price, quantity: 1)

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

  it "I can see all of my items and their info as well as a link to deactivate/activate that item" do
    click_link "Items"

    within "#item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_content(@paper.price)
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content("active")
      expect(page).to have_content(@paper.inventory)
      expect(page).to have_link("deactivate")
      click_link "deactivate"
    end

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@paper.name} is no longer for sale.")
    
    within "#item-#{@pencil.id}" do
      expect(page).to have_content(@pencil.name)
      expect(page).to have_content(@pencil.description)
      expect(page).to have_content(@pencil.price)
      expect(page).to have_css("img[src*='#{@pencil.image}']")
      expect(page).to have_content("active")
      expect(page).to have_content(@pencil.inventory)
      expect(page).to have_link("deactivate")
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_content(@paper.price)
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content("inactive")
      expect(page).to have_content(@paper.inventory)
      expect(page).to have_link("activate")
      click_link "activate"
    end

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@paper.name} is now available for sale.")

    within "#item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_content(@paper.price)
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content("active")
      expect(page).to have_content(@paper.inventory)
      expect(page).to have_link("deactivate")
    end
  end

  it "I can delete an item from my index page only if the item doesnt have orders on it" do
    click_link "Items"

    within "#item-#{@paper.id}" do
      expect(page).to_not have_link("delete")
    end

    within "#item-#{@pencil.id}" do
      expect(page).to have_link("delete")
      click_link "delete"
    end

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@pencil.name} has been successfully deleted.")
    expect(page).to_not have_css("img[src*='#{@pencil.image}']")
  end

  it "I see a link to add a new item to my index page" do
    click_link "Items"

    expect(page).to have_link("Add New Item")

    click_link "Add New Item"

    expect(current_path).to eq("/merchant/items/new")

    fill_in :name, with: 'Cream'
    fill_in :description, with: 'description'
    fill_in :image, with: ''
    fill_in :price, with: '1.00'
    fill_in :inventory, with: '3'

    click_button "Create New Item"

    new_item = @print_shop.items.last

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{new_item.name} has been added to your items.")

    within "#item-#{new_item.id}"do
      expect(page).to have_content("Cream")
      expect(page).to have_content("description")
      expect(page).to have_content("1")
      expect(page).to have_content("3")
      expect(page).to have_content("active")
    end
  end

  it "Add a new item blank name sad path" do
    visit '/merchant/items/new'

    fill_in :name, with: ''
    fill_in :description, with: 'description'
    fill_in :image, with: ''
    fill_in :price, with: '1.00'
    fill_in :inventory, with: '0'

    click_button "Create New Item"

    expect(find_field('Name').value).to eq ''
    expect(find_field('Description').value).to eq 'description'
    expect(find_field('Price').value).to eq "1"
    expect(find_field('Inventory').value).to eq("0")

    expect(page).to have_content("Name can't be blank")
  end

  it "Add a new item less than zero inventory sad path" do
    visit '/merchant/items/new'

    fill_in :name, with: 'Creamy'
    fill_in :description, with: 'description'
    fill_in :image, with: ''
    fill_in :price, with: '1.00'
    fill_in :inventory, with: '-1'

    click_button "Create New Item"

    expect(find_field('Name').value).to eq 'Creamy'
    expect(find_field('Description').value).to eq 'description'
    expect(find_field('Price').value).to eq "1"
    expect(find_field('Inventory').value).to eq "-1"

    expect(page).to have_content("Inventory must be greater than or equal to 0")
  end
end
