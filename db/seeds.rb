# encoding: UTF-8
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
  { :name => 'user' }
], :without_protection => true)

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'User 1', :email => 'brook@brook.com', :password => '123456', :password_confirmation => '123456'
puts 'New user created: ' << user.name

user2 = User.create! :name => 'User 2', :email => 'manager@brook.com', :password => '123456', :password_confirmation => '123456'
puts 'New user created: ' << user2.name

user3 = User.create! :name => 'User 3', :email => 'user@brook.com', :password => '123456', :password_confirmation => '123456'
puts 'New user created: ' << user3.name

user.add_role :admin
user2.add_role :manager
user3.add_role :user
puts 'New users role add. '

puts "CREATING 茶叶种类"
Lookup.create([
  {:code => 'tgy', :category => '茶叶种类', :description => '铁观音' },
  {:code => 'puer', :category =>'茶叶种类', :description => '普洱'},
  {:code => 'lc', :category => '茶叶种类', :description => '绿茶'},
  {:code => 'hc', :category => '茶叶种类', :description => '红茶'}
], :without_protection => true)

puts 'CREATING products'
Product.create([
  {:name => '铁观音秋茶2012', :category => 'tgy', :description => '铁观音秋茶2012', :measurement => '克', :unit_price => '1.2' },
  {:name => '大益普洱2005', :category => 'puer', :description => '大益普洱2005', :measurement => '饼', :unit_price => '200' },
  {:name => '正山小种2011', :category => 'hc', :description => '正山小种2011', :measurement => '克', :unit_price => '3.0' },
  {:name => '西湖龙井2012', :category => 'lc', :description => '西湖龙井2012', :measurement => '克', :unit_price => '2.0' }
], :without_protection => true)


puts "Creating stores"
Store.create([
  {:name => '信誉大街店', :category => '分店', :remark => '信誉大街XX号' },
  {:name => '才培店', :category => '入驻', :remark => '才培大厦一楼'},
  {:name => 'xx店', :category => '总部', :remark => 'XXX路XXX号'}
], :without_protection => true)

