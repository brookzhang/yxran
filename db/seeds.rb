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
  {:code => 'I', :category =>'adjust_type', :description => '初始库存'},
  {:code => 'O', :category =>'adjust_type', :description => '订单'},
  {:code => 'OE', :category =>'adjust_type', :description => '订单修改'},
  {:code => 'T', :category =>'adjust_type', :description => '调货'},
  {:code => 'TE', :category =>'adjust_type', :description => '调货修改'},
  {:code => 'S', :category =>'adjust_type', :description => '销售'},
  {:code => 'SE', :category =>'adjust_type', :description => '销售修改'},
  {:code => 'R', :category =>'sale_category', :description => '零售'},
  {:code => 'C', :category =>'sale_category', :description => '消耗'},
  {:code => 'M', :category =>'sale_category', :description => '会员'},
  
  {:code => '1', :category =>'sale_status', :description => '已入账'},
  {:code => '9', :category =>'sale_status', :description => '已撤销'},
  
  {:code => '0', :category =>'handover_status', :description => '接班'},
  {:code => '1', :category =>'handover_status', :description => '交班'},
  
  {:code => 'C', :category =>'expense_category', :description => '办公用品'},
  {:code => 'D', :category =>'expense_category', :description => '整额支取'},
  {:code => 'O', :category =>'expense_category', :description => '其他'},
  
  {:code => '1', :category =>'expense_status', :description => '已入账'},
  {:code => '9', :category =>'expense_status', :description => '已撤销'},
  
  {:code => 'S', :category =>'balance_category', :description => '销售'},
  {:code => 'E', :category =>'balance_category', :description => '开支'},
  
  {:code => '0', :category =>'user_status', :description => '锁定'},
  {:code => '1', :category =>'user_status', :description => '可用'},
  
  {:code => '0', :category =>'store_status', :description => '禁用'},
  {:code => '1', :category =>'store_status', :description => '正常'},
  
  {:code => '0', :category =>'transfer_status', :description => '准备中'},
  {:code => '1', :category =>'transfer_status', :description => '已出货'},
  {:code => '2', :category =>'transfer_status', :description => '已接收'},
  {:code => '3', :category =>'transfer_status', :description => '部分接收'},
  {:code => '9', :category =>'transfer_status', :description => '已取消'},
  
  {:code => '0', :category =>'order_status', :description => '准备中'},
  {:code => '1', :category =>'order_status', :description => '已入仓'},
  
  
  {:code => 'admin', :category =>'role', :description => '系统管理员'},
  {:code => 'manager', :category =>'role', :description => '主管'},
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


puts 'creating roles'
Role.create([
  { :name => 'admin' }, 
  { :name => 'manager' }, 
  { :name => 'stocker' }, 
  { :name => 'user' }
], :without_protection => true)

puts 'creating users'
User.create([
  {:account => 'yxrana', :name => '管理员', :email => 'admin@yxran.com', :password => '123456', :password_confirmation => '123456'},
  {:account => 'yxranm', :name => '经理', :email => 'manager@yxran.com', :password => '123456', :password_confirmation => '123456'},
  {:account => 'fengyang', :name => '老板', :email => 'fengyang@yxran.com', :password => '123456', :password_confirmation => '123456'},
  {:account => 'ku01', :name => '库管员1', :email => 'stocker@yxran.com', :password => '123456', :password_confirmation => '123456'},
])

puts 'Adding roles'
User.find(1).add_role :admin
User.find(2).add_role :manager
User.find(3).add_role :manager
User.find(4).add_role :stocker










if ENV["RAILS_ENV"] != 'production'
  
  puts 'creating products'
  Product.create([
    {:name => '西湖龙井2012', :category_id => '3', :description => '西湖龙井2012', :measurement => '克', :unit_price => '0.8' },
    {:name => '正山小种2011', :category_id => '4', :description => '正山小种2011', :measurement => '克', :unit_price => '0.5' },
    {:name => '铁观音秋茶2012', :category_id => '5', :description => '铁观音秋茶2012', :measurement => '克', :unit_price => '0.4'},
    {:name => '大益普洱2005', :category_id => '6', :description => '大益普洱2005', :measurement => '饼', :unit_price => '200' },
    {:name => '久扬黑茶', :category_id => '7', :description => '久扬黑茶', :measurement => '饼', :unit_price => '80' },
    {:name => '岩茶-肉桂', :category_id => '8', :description => '岩茶-肉桂', :measurement => '克', :unit_price => '0.2' }
  ], :without_protection => true)
  
  
  puts "creating stores"
  Store.create([
    {:name => '总店', :category => 'C', :balance => 1000, :remark => 'XXX路XXX号'},
    {:name => '信誉大街店', :category => 'P', :balance => 800, :remark => '信誉大街XX号' },
    {:name => '才培店', :category => 'I', :balance => 700, :remark => '才培大厦一楼'},
    {:name => '总部仓库', :category => 'S', :balance => 600, :remark => 'XXX路XXX号'}
  ], :without_protection => true)
  
  puts "inserting inventory"
  Stock.create([
    {:product_id => 1, :store_id => 1, :quantity => 41000, :safe_stock => 5000, :remark => '西湖龙井', :adjust_type => 'I'},
    {:product_id => 2, :store_id => 1, :quantity => 31000, :safe_stock => 5000, :remark => '正山小种', :adjust_type => 'I'},
    {:product_id => 3, :store_id => 1, :quantity => 21000, :safe_stock => 5000, :remark => '铁观音秋茶', :adjust_type => 'I'},
    {:product_id => 4, :store_id => 1, :quantity => 31000, :safe_stock => 5000, :remark => '大益普洱', :adjust_type => 'I'},
    {:product_id => 5, :store_id => 1, :quantity => 21000, :safe_stock => 5000, :remark => '久扬黑茶', :adjust_type => 'I'},
    {:product_id => 6, :store_id => 1, :quantity => 41000, :safe_stock => 5000, :remark => '岩茶', :adjust_type => 'I'},
    {:product_id => 1, :store_id => 2, :quantity => 42000, :safe_stock => 5000, :remark => '西湖龙井', :adjust_type => 'I'},
    {:product_id => 2, :store_id => 2, :quantity => 32000, :safe_stock => 5000, :remark => '正山小种', :adjust_type => 'I'},
    {:product_id => 3, :store_id => 2, :quantity => 22000, :safe_stock => 5000, :remark => '铁观音秋茶', :adjust_type => 'I'},
    {:product_id => 4, :store_id => 2, :quantity => 32000, :safe_stock => 5000, :remark => '大益普洱', :adjust_type => 'I'},
    {:product_id => 5, :store_id => 2, :quantity => 22000, :safe_stock => 5000, :remark => '久扬黑茶', :adjust_type => 'I'},
    {:product_id => 6, :store_id => 2, :quantity => 42000, :safe_stock => 5000, :remark => '岩茶', :adjust_type => 'I'},
    {:product_id => 1, :store_id => 3, :quantity => 43000, :safe_stock => 5000, :remark => '西湖龙井', :adjust_type => 'I'},
    {:product_id => 2, :store_id => 3, :quantity => 33000, :safe_stock => 5000, :remark => '正山小种', :adjust_type => 'I'},
    {:product_id => 3, :store_id => 3, :quantity => 23000, :safe_stock => 5000, :remark => '铁观音秋茶', :adjust_type => 'I'},
    {:product_id => 4, :store_id => 3, :quantity => 33000, :safe_stock => 5000, :remark => '大益普洱', :adjust_type => 'I'},
    {:product_id => 5, :store_id => 3, :quantity => 23000, :safe_stock => 5000, :remark => '久扬黑茶', :adjust_type => 'I'},
    {:product_id => 6, :store_id => 3, :quantity => 43000, :safe_stock => 5000, :remark => '岩茶', :adjust_type => 'I'}
    
  ])
  
  
  puts 'creating users'
  User.create([
    {:account => 'dian01', :name => '店员甲', :email => 'a@yxran.com', :password => '123456', :password_confirmation => '123456'},
    {:account => 'dian02', :name => '店员乙', :email => 'b@yxran.com', :password => '123456', :password_confirmation => '123456'}
  ])
  
  puts 'Adding roles'
  User.find(5).add_role :user
  User.find(6).add_role :user
  
  puts 'Adding members'
  Member.create([
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张观博', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 3},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张欣竹', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 4},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张欣阳', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 3},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张晨菲', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 4},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张涵韵', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 3},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张晨曦', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 4},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张晓朋', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 3},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张子辰', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 4},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张展旭', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 3},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张怡萍', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 4},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张浩然', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 3},
    {:uuid => UUIDTools::UUID.random_create().to_s, :name => '
  张继欣', :phone => '13312345678', :address => 'XX市XX路XX号', :remark => '测试会员', :user_id => 4}
  ])  
  
  puts 'The End'
end


