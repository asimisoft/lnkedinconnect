# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# admin = Admin.find_or_initialize_by(:email => "admin@gmail.com", :password => "123123123")
# admin.save(:validate => false)


users = [
  {email: "user@example.com", password: '123123123', role: 'standard'}, 
  {email: "user2@example.com", password: '123123123', role: 'admin'}, 
]

users.each do |user|
  u = User.new(user)
  u.save(validate: false)
end
