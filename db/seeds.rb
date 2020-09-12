# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

#user/merchant/admin
@user = User.create!(name: 'Billy Joel',
                    address: '123 Song St.',
                    city: 'Las Vegas',
                    state: 'NV',
                    zip: '12345',
                    email: 'billy_j@user.com',
                    password: '123',
                    role: 0)

@user2 = User.create!(name: 'Bill J',
                    address: '123 Meledy St.',
                    city: 'Denver',
                    state: 'CO',
                    zip: '54321',
                    email: 'bill_j@user.com',
                    password: '321',
                    role: 0)

@merchant = User.create!(name: 'Joel Billy',
                        address: '125 Song St.',
                        city: 'Las Vegas',
                        state: 'NV',
                        zip: '12345',
                        email: 'billy_j@merchant.com',
                        password: '123',
                        role: 1)

@admin = User.create!(name: 'Chilly Billy',
                      address: '125 Song St.',
                      city: 'Las Vegas',
                      state: 'NV',
                      zip: '12345',
                      email: 'chilly_b@admin.com',
                      password: '123',
                      role: 2)

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12, quantity_purchased: 0)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32, quantity_purchased: 0)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21, quantity_purchased: 0)
