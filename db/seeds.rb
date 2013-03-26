# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



puts "creating lookups"
Lookup.create([
  {:code => 'S', :category =>'event', :description => '修改设定' },
  {:code => 'U', :category =>'event', :description => '用户修改'},
  {:code => 'C', :category =>'event', :description => '产品分类'},
  {:code => 'DS', :category =>'event', :description => '产品折扣'},
  {:code => 'C', :category =>'store', :description => '总部'},
  {:code => 'P', :category =>'store', :description => '分店'},
  {:code => 'I', :category =>'store', :description => '入驻'},
  {:code => 'S', :category =>'store', :description => '仓库'},
  {:code => 'O', :category =>'adjust_type', :description => '订单'},
  {:code => 'OE', :category =>'adjust_type', :description => '订单修改'},
  {:code => 'T', :category =>'adjust_type', :description => '调货'},
  {:code => 'TE', :category =>'adjust_type', :description => '调货修改'},
  {:code => 'S', :category =>'adjust_type', :description => '销售'},
  {:code => 'SE', :category =>'adjust_type', :description => '销售修改'},
  {:code => 'D', :category =>'discount_type', :description => '算折扣'},
  {:code => 'S', :category =>'discount_type', :description => '记积分'},
  {:code => 'R', :category =>'sale_category', :description => '零售'},
  {:code => 'C', :category =>'sale_category', :description => '消耗'},
  {:code => 'M', :category =>'sale_category', :description => '会员'},
  
  {:code => 'admin', :category =>'role', :description => '管理员'},
  {:code => 'manager', :category =>'role', :description => '经理'},
  {:code => 'user', :category =>'role', :description => '店员'},
  {:code => '0', :category =>'member', :description => '普通会员'},
  {:code => '1', :category =>'member', :description => '高级会员'},
  {:code => '9', :category =>'member', :description => '贵宾'}
], :without_protection => true)

puts "creating switches"
Switch.create([
  {:key => 'default_discount', :value => '0.1', :description => '默认折扣' }
], :without_protection => true)

puts "creating categories of products"
Category.create([
  {:parent_id => '0', :name => '茶叶', :description => '茶叶种类', :sequence => '1' },
  {:parent_id => '0', :name => '茶具', :description => '茶具', :sequence => '2' },
  {:parent_id => '1', :name => '绿茶', :description => '绿茶', :sequence =>'1' },
  {:parent_id => '1', :name => '红茶', :description => '红茶', :sequence => '2' },
  {:parent_id => '1', :name => '铁观音', :description => '铁观音', :sequence => '3' },
  {:parent_id => '1', :name => '普洱茶', :description => '普洱茶', :sequence => '4' },
  {:parent_id => '1', :name => '黑茶', :description => '黑茶', :sequence => '5' },
  {:parent_id => '1', :name => '乌龙茶', :description => '乌龙茶', :sequence => '6' },
  {:parent_id => '2', :name => '茶壶', :description => '茶壶', :sequence => '1' },
  {:parent_id => '2', :name => '茶杯', :description => '茶杯', :sequence => '2' },
  {:parent_id => '2', :name => '茶盘', :description => '茶盘', :sequence => '3' },
  {:parent_id => '2', :name => '套件', :description => '套件', :sequence => '4' },
  {:parent_id => '2', :name => '配件', :description => '配件', :sequence => '5' }
], :without_protection => true)

puts 'creating discounts'
Discount.create([
  {:category_id => 1, :member_level => '0', :discount => 0.1 },
  {:category_id => 2, :member_level => '0', :discount => 0.1 },
  {:category_id => 1, :member_level => '1', :discount => 0.15 },
  {:category_id => 2, :member_level => '1', :discount => 0.15 },
  {:category_id => 1, :member_level => '9', :discount => 0.2 },
  {:category_id => 2, :member_level => '9', :discount => 0.15 }
], :without_protection => true)

puts 'creating products'
Product.create([
  {:name => '铁观音秋茶2012', :category_id => '5', :description => '铁观音秋茶2012', :measurement => '克', :unit_price => '1.2'},
  {:name => '大益普洱2005', :category_id => '6', :description => '大益普洱2005', :measurement => '饼', :unit_price => '200' },
  {:name => '正山小种2011', :category_id => '4', :description => '正山小种2011', :measurement => '克', :unit_price => '3.0' },
  {:name => '西湖龙井2012', :category_id => '3', :description => '西湖龙井2012', :measurement => '克', :unit_price => '2.0' }
], :without_protection => true)


puts "creating stores"
Store.create([
  {:name => '总店', :category => 'c', :remark => 'XXX路XXX号'},
  {:name => '信誉大街店', :category => 'p', :remark => '信誉大街XX号' },
  {:name => '才培店', :category => 'i', :remark => '才培大厦一楼'},
  {:name => '总部仓库', :category => 's', :remark => 'XXX路XXX号'}
], :without_protection => true)


puts 'creating roles'
Role.create([
  { :name => 'admin' }, 
  { :name => 'manager' }, 
  { :name => 'user' }
], :without_protection => true)

puts 'creating users'
User.create([
  {:name => 'admin', :email => 'admin@yxran.com', :store_id => '1', :password => '123456', :password_confirmation => '123456'},
  {:name => 'manager', :email => 'manager@yxran.com', :store_id => '2', :password => '123456', :password_confirmation => '123456'},
  {:name => 'user', :email => 'user@yxran.com', :store_id => '3', :password => '123456', :password_confirmation => '123456'}
])

puts 'Adding roles'
User.find(1).add_role :admin
User.find(2).add_role :manager
User.find(3).add_role :user
