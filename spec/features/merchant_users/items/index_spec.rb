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
end
