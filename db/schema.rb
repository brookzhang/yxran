# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121215070114) do

  create_table "histories", :id => false, :force => true do |t|
    t.integer  "stock_id"
    t.string   "adjust_type"
    t.integer  "reference_id"
    t.integer  "adjusted_by"
    t.integer  "adjusted_to"
    t.datetime "adjusted_at"
    t.string   "remark"
  end

  add_index "histories", ["stock_id", "adjust_type", "adjusted_at"], :name => "index_histories_on_stock_id_and_adjust_type_and_adjusted_at"

  create_table "lookups", :force => true do |t|
    t.string   "code"
    t.string   "category"
    t.string   "description"
    t.integer  "sequence"
    t.integer  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "lookups", ["code", "category"], :name => "index_lookups_on_code_and_category"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "category"
    t.string   "measurement"
    t.float    "unit_price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "products", ["name", "category"], :name => "index_products_on_name_and_category"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "stocks", :id => false, :force => true do |t|
    t.integer  "product_id"
    t.integer  "store_id"
    t.integer  "quantity"
    t.integer  "safe_stock"
    t.string   "remark"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stocks", ["product_id", "store_id"], :name => "index_stocks_on_product_id_and_store_id"

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "remark"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stores", ["name", "category"], :name => "index_stores_on_name_and_category"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
