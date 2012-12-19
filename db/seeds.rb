# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



puts "CREATING 茶叶种类"
Lookup.create([
  {:code => 'tgy', :category => 'tea_type', :description => '铁观音' },
  {:code => 'puer', :category =>'tea_type', :description => '普洱'},
  {:code => 'lc', :category => 'tea_type', :description => '绿茶'},
  {:code => 'hc', :category => 'tea_type', :description => '红茶'}
], :without_protection => true)

puts 'CREATING products'
Product.create([
  {:name => '铁观音秋茶2012', :category => 'tgy', :description => '铁观音秋茶2012', :measurement => '克', :unit_price => '1.2'},
  {:name => '大益普洱2005', :category => 'puer', :description => '大益普洱2005', :measurement => '饼', :unit_price => '200' },
  {:name => '正山小种2011', :category => 'hc', :description => '正山小种2011', :measurement => '克', :unit_price => '3.0' },
  {:name => '西湖龙井2012', :category => 'lc', :description => '西湖龙井2012', :measurement => '克', :unit_price => '2.0' }
], :without_protection => true)


puts "Creating stores"
Store.create([
  {:name => '总部仓库', :category => '总部', :remark => 'XXX路XXX号'},
  {:name => '信誉大街店', :category => '分店', :remark => '信誉大街XX号' },
  {:name => '才培店', :category => '入驻', :remark => '才培大厦一楼'}
], :without_protection => true)


puts 'CREATING ROLES'
Role.create([
  { :name => 'admin' }, 
  { :name => 'manager' }, 
  { :name => 'user' }
], :without_protection => true)

puts 'Create users'
User.create([
  {:name => 'admin', :email => 'brook@brook.com', :store_id => '1', :password => '123456', :password_confirmation => '123456'},
  {:name => 'manager', :email => 'manager@brook.com', :store_id => '2', :password => '123456', :password_confirmation => '123456'},
  {:name => 'user', :email => 'user@brook.com', :store_id => '3', :password => '123456', :password_confirmation => '123456'}
])

puts 'Users roles add. '
User.find(1).add_role :admin
User.find(2).add_role :manager
User.find(3).add_role :user
