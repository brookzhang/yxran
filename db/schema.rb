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

ActiveRecord::Schema.define(:version => 20130718042741) do

  create_table "balances", :force => true do |t|
    t.integer  "store_id"
    t.integer  "user_id"
    t.string   "category"
    t.integer  "reference_id"
    t.float    "adjusted_by"
    t.float    "adjusted_to"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "balances", ["store_id", "user_id", "reference_id"], :name => "index_balances_on_store_id_and_user_id_and_reference_id"

  create_table "carts", :force => true do |t|
    t.integer  "product_id"
    t.integer  "store_id"
    t.integer  "user_id"
    t.integer  "quantity"
    t.float    "unit_price"
    t.float    "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "description"
    t.integer  "sequence"
    t.integer  "status",      :default => 1
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "discounts", :force => true do |t|
    t.integer  "category_id"
    t.integer  "member_level"
    t.float    "discount"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "discounts", ["category_id", "member_level"], :name => "index_discounts_on_category_id_and_member_level"

  create_table "events", :force => true do |t|
    t.string   "category"
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "events", ["category", "user_id"], :name => "index_events_on_category_and_user_id"

  create_table "expenses", :force => true do |t|
    t.integer  "store_id"
    t.integer  "user_id"
    t.string   "category"
    t.float    "amount"
    t.string   "remark"
    t.integer  "status",     :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "expenses", ["store_id", "user_id"], :name => "index_expenses_on_store_id_and_user_id"

  create_table "handovers", :force => true do |t|
    t.integer  "store_id"
    t.integer  "user_id"
    t.integer  "status",      :default => 0
    t.float    "take_amount"
    t.float    "hand_amount"
    t.string   "take_remark"
    t.string   "hand_remark"
    t.datetime "took_at"
    t.datetime "handed_at"
  end

  add_index "handovers", ["store_id", "user_id"], :name => "index_handovers_on_store_id_and_user_id"

  create_table "lookups", :force => true do |t|
    t.string   "code"
    t.string   "category"
    t.string   "description"
    t.integer  "sequence"
    t.integer  "status",      :default => 1
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "lookups", ["code", "category"], :name => "index_lookups_on_code_and_category"

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.string   "remark"
    t.integer  "level",      :default => 0
    t.float    "score",      :default => 0.0
    t.float    "all_score",  :default => 0.0
    t.integer  "user_id"
    t.string   "uuid"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "members", ["name", "phone"], :name => "index_members_on_name_and_phone"

  create_table "order_details", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.float    "amount"
    t.string   "remark"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "order_details", ["product_id"], :name => "index_order_details_on_product_id"

  create_table "orders", :force => true do |t|
    t.integer  "store_id"
    t.string   "remark"
    t.integer  "status",     :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"

  create_table "product_prices", :force => true do |t|
    t.integer "product_id"
    t.integer "store_id"
    t.float   "unit_price"
  end

  create_table "product_units", :force => true do |t|
    t.string   "name"
    t.integer  "base_unit"
    t.integer  "base_unit_count"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.string   "description"
    t.float    "unit_price"
    t.integer  "status",          :default => 1
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "product_unit_id"
    t.string   "tag"
  end

  add_index "products", ["name", "category_id"], :name => "index_products_on_name_and_category_id"
  add_index "products", ["tag"], :name => "index_products_on_tag"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sale_details", :force => true do |t|
    t.integer  "sale_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.float    "unit_price"
    t.float    "amount"
    t.float    "discount"
    t.string   "remark"
    t.integer  "status",     :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "sale_details", ["product_id"], :name => "index_sale_details_on_product_id"

  create_table "sales", :force => true do |t|
    t.integer  "store_id"
    t.integer  "user_id"
    t.integer  "member_id"
    t.string   "category"
    t.float    "amount"
    t.float    "actual_amount"
    t.float    "score",         :default => 0.0
    t.float    "used_score",    :default => 0.0
    t.string   "remark"
    t.integer  "status",        :default => 1
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "sales", ["store_id", "member_id"], :name => "index_sales_on_store_id_and_member_id"

  create_table "stock_histories", :force => true do |t|
    t.integer  "stock_id"
    t.integer  "user_id"
    t.string   "adjust_type"
    t.integer  "reference_id"
    t.integer  "adjusted_by"
    t.integer  "adjusted_to"
    t.datetime "adjusted_at"
    t.string   "remark"
  end

  add_index "stock_histories", ["adjust_type"], :name => "index_stock_histories_on_adjust_type"
  add_index "stock_histories", ["stock_id"], :name => "index_stock_histories_on_stock_id"

  create_table "stocks", :force => true do |t|
    t.integer  "product_id"
    t.integer  "store_id"
    t.integer  "quantity"
    t.integer  "safe_stock"
    t.string   "remark"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stocks", ["product_id", "store_id"], :name => "index_stocks_on_product_id_and_store_id"

  create_table "store_users", :force => true do |t|
    t.integer  "store_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.float    "balance",    :default => 0.0
    t.string   "remark"
    t.integer  "status",     :default => 1
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "stores", ["name", "category"], :name => "index_stores_on_name_and_category"

  create_table "switches", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "description"
    t.integer  "status",      :default => 1
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "switches", ["key", "value"], :name => "index_switches_on_key_and_value"

  create_table "transfer_details", :force => true do |t|
    t.integer  "transfer_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "remark"
    t.integer  "status",      :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "transfer_details", ["product_id"], :name => "index_transfer_details_on_product_id"

  create_table "transfers", :force => true do |t|
    t.integer  "from_store_id"
    t.integer  "to_store_id"
    t.string   "transfer_remark"
    t.string   "receive_remark"
    t.integer  "status",          :default => 0
    t.integer  "transferer_id"
    t.integer  "receiver_id"
    t.datetime "transfered_at"
    t.datetime "received_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "type",            :default => "T"
  end

  add_index "transfers", ["from_store_id", "to_store_id"], :name => "index_transfers_on_from_store_id_and_to_store_id"

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
    t.integer  "store_id"
    t.integer  "status",                 :default => 1
    t.string   "account"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
