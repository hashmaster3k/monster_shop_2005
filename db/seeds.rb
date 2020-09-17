# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#user/merchant/admin
user = User.create!(name: 'Billy Joel',
                    address: '123 Song St.',
                    city: 'Las Vegas',
                    state: 'NV',
                    zip: '12345',
                    email: 'user',
                    password: '123',
                    role: 0)

merchant = User.create!(name: 'Joel Billy',
                        address: '125 Song St.',
                        city: 'Las Vegas',
                        state: 'NV',
                        zip: '12345',
                        email: 'merchant',
                        password: '123',
                        merchant_id: bike_shop.id,
                        role: 1)

admin = User.create!(name: 'Chilly Billy',
                      address: '125 Song St.',
                      city: 'Las Vegas',
                      state: 'NV',
                      zip: '12345',
                      email: 'admin',
                      password: '123',
                      role: 2)


#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12, quantity_purchased: 0)
chain = bike_shop.items.create(name: "2 Chains", description: "A set of two chains", price: 50, image: "https://ae01.alicdn.com/kf/H8f6e71c582f6409ebf1374828507faefM.jpg", inventory: 6, quantity_purchased: 0)
pedal = bike_shop.items.create(name: "Pair-o-Pedals", description: "Sweet set of pedals", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/81dGmYwAimL._AC_SL1500_.jpg", inventory: 7, quantity_purchased: 0)
handle_bar = bike_shop.items.create(name: "Handle Bar", description: "Best Handles on earth", price: 25, image: "https://i0.wp.com/rinascltabike.com/wp-content/uploads/2019/04/Rinasclta-integrated-carbon-handlebar.jpg", inventory: 2, quantity_purchased: 0)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32, quantity_purchased: 0)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21, quantity_purchased: 0)
donut = dog_shop.items.create(name: "Donut Squeaker", description: "Mmmmm donuts", price: 8, image: "https://ae01.alicdn.com/kf/HTB1AivzXkT2gK0jSZFkq6AIQFXaz.jpg", inventory: 12, quantity_purchased: 0)
ball = dog_shop.items.create(name: "Chuck It Ball", description: "Indestructable", price: 4, image: "https://img.chewy.com/is/image/catalog/64771_MAIN._AC_SL400_V1543519093_.jpg", inventory: 20, quantity_purchased: 0)
kong = dog_shop.items.create(name: "Kong", description: "Keep your dog busy for hours", price: 3, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 18, quantity_purchased: 0)
