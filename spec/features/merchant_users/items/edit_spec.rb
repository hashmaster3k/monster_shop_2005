require 'rails_helper'

RSpec.describe 'Merchant dashboard items edit' do
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

# User Story 47, Merchant edits an item
#
# As a merchant employee
# When I visit my items page
# And I click the edit button or link next to any item
# Then I am taken to a form similar to the 'new item' form
# The form is pre-populated with all of this item's information
# I can change any information, but all of the rules for adding a new item still apply:
# - name and description cannot be blank
# - price cannot be less than $0.00
# - inventory must be 0 or greater
#
# When I submit the form
# I am taken back to my items page
# I see a flash message indicating my item is updated
# I see the item's new information on the page, and it maintains its previous enabled/disabled state
# If I left the image field blank, I see a placeholder image for the thumbnail

  it "I can edit an items information" do
    click_link "Items"

    within "#item-#{@pencil.id}" do
      expect(page).to have_link("Edit Item")
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_link("Edit Item")
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@paper.id}/edit")

    expect(find_field('Name').value).to eq @paper.name
    expect(find_field('Description').value).to eq @paper.description
    expect(find_field('Image').value).to eq @paper.image
    expect(find_field('Price').value).to eq @paper.price.to_s
    expect(find_field('Inventory').value).to eq @paper.inventory.to_s

    fill_in :description, with: 'edited description'

    click_button "Update Item"

    expect(current_path).to eq("/merchant/items")

    within "#item-#{@paper.id}" do
      expect(page).to have_content("edited description")
    end

    expect(page).to have_content("#{@paper.name} was successfully updated.")
  end

  it "I can edit an items information sad path" do
    click_link "Items"

    within "#item-#{@pencil.id}" do
      expect(page).to have_link("Edit Item")
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_link("Edit Item")
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@paper.id}/edit")

    expect(find_field('Name').value).to eq @paper.name
    expect(find_field('Description').value).to eq @paper.description
    expect(find_field('Image').value).to eq @paper.image
    expect(find_field('Price').value).to eq @paper.price.to_s
    expect(find_field('Inventory').value).to eq @paper.inventory.to_s

    fill_in :description, with: ''

    click_button "Update Item"

    expect(page).to have_content("Description can't be blank")
  end
end
