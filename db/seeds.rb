# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do |i|
  Category.create(name: "category##{i}")
  Product.create(category_id: i+1, name: "product##{i}")
  Availability.create(product_id: i+1, amount: i+10, end_date: DateTime.now, price: i+100)
  Provider.create(address: "address##{i}", phone: "0987654321#{i}")
  Delivery.create(provider_id: i+1, product_id: i+1, price: i+100, amount: i+10, delivery_date: DateTime.now, end_date: DateTime.now)
end
