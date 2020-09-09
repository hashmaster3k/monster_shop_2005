# As a visitor
# I see a navigation bar
# This navigation bar includes links for the following:
# - a link to return to the welcome / home page of the application ("/")
# - a link to browse all items for sale ("/items")
# - a link to see all merchants ("/merchants")
# - a link to my shopping cart ("/cart")
# - a link to log in ("/login")
# - a link to the user registration page ("/register")
#
# Next to the shopping cart link I see a count of the items in my cart

require 'rails_helper'

RSpec.describe 'visitor navigation' do

  describe 'visitor nav bar approved pathways' do
    it 'includes links: return to welcome page, browse all items, see all merchants, my shopping cart, log in, user registration page' do
      visit '/merchants'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
        expect(page).to have_link("All Items", href: "/items")
        expect(page).to have_link("All Merchants", href: "/merchants")
        expect(page).to have_link("Cart: 0", href: "/cart")
        expect(page).to have_link("Log in", href: "/login")
        expect(page).to have_link("Register", href: "/register")
      end
    end
  end

  describe 'visitor restricted pathways' do
    it 'visitor cannot access pathways designated for users, merchants, or admins' do
      visit '/merchant'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/profile'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")

    end
  end

end
