# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'CREATING ROLES'
Role.create([
  { :name => 'admin' }, 
  { :name => 'manager' }, 
  { :name => 'user' },
  { :name => 'VIP' },
  { :name => 'member' }
], :without_protection => true)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'User 1', :email => 'brook@brook.com', :password => '123456', :password_confirmation => '123456'
puts 'New user created: ' << user.name
user2 = User.create! :name => 'User 2', :email => 'manager@brook.com', :password => '123456', :password_confirmation => '123456'
puts 'New user created: ' << user2.name
user3 = User.create! :name => 'User 3', :email => 'user@brook.com', :password => '123456', :password_confirmation => '123456'
puts 'New user created: ' << user3.name
user4 = User.create! :name => 'User 4', :email => 'member@brook.com', :password => '123456', :password_confirmation => '123456'
puts 'New user created: ' << user4.name
user.add_role :admin
user2.add_role :manager
user3.add_role :user
user4.add_role :member