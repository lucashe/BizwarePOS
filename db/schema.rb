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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140923154403) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branch_items", force: true do |t|
    t.integer  "branch_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_amount"
    t.integer  "amount_sold",  default: 0
  end

  create_table "branches", force: true do |t|
    t.integer  "store_id"
    t.string   "branch_name"
    t.text     "branch_description"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "website_url"
    t.string   "addr_floor"
    t.string   "addr_unit"
    t.string   "addr_block"
    t.string   "addr_street"
    t.string   "addr_building"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.boolean  "published",                             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id"
    t.string   "ic"
    t.decimal  "rewards",       precision: 8, scale: 2, default: 0.0
    t.string   "status"
  end

  create_table "item_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id"
  end

  create_table "items", force: true do |t|
    t.string   "sku"
    t.string   "name"
    t.text     "description"
    t.decimal  "price",            precision: 8, scale: 2
    t.decimal  "cost_price",       precision: 8, scale: 2
    t.boolean  "published",                                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_category_id"
    t.text     "image"
    t.integer  "store_id"
    t.text     "qr_code_uid"
    t.text     "qr_code_name"
  end

  create_table "line_items", force: true do |t|
    t.integer  "item_id"
    t.integer  "quantity",                            default: 1
    t.decimal  "price",       precision: 8, scale: 2
    t.decimal  "total_price", precision: 8, scale: 2
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cost",        precision: 8, scale: 2
    t.decimal  "total_cost",  precision: 8, scale: 2
  end

  create_table "members", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree

  create_table "payments", force: true do |t|
    t.integer  "sale_id"
    t.decimal  "amount",       precision: 8, scale: 2
    t.string   "payment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales", force: true do |t|
    t.decimal  "amount",           precision: 8, scale: 2, default: 0.0
    t.decimal  "total_amount",     precision: 8, scale: 2, default: 0.0
    t.decimal  "remaining_amount",                         default: 0.0
    t.decimal  "discount",         precision: 8, scale: 2, default: 0.0
    t.decimal  "tax",              precision: 8, scale: 2, default: 0.0
    t.integer  "customer_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
    t.integer  "user_id"
    t.decimal  "rewards_earned",   precision: 8, scale: 2, default: 0.0
    t.decimal  "rewards_used",     precision: 8, scale: 2, default: 0.0
    t.decimal  "cost",             precision: 8, scale: 2, default: 0.0
    t.boolean  "is_final",                                 default: false
  end

  create_table "stores", force: true do |t|
    t.string   "store_name"
    t.text     "store_description"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "website_url"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "currency"
    t.decimal  "tax_rate",          precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enable_member",                             default: false
    t.integer  "member_discount",                           default: 0
    t.integer  "member_reward",                             default: 0
  end

  create_table "user_employments", force: true do |t|
    t.integer  "user_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                 default: "",    null: false
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "can_update_users",         default: false
    t.boolean  "can_update_items",         default: true
    t.boolean  "can_update_configuration", default: false
    t.boolean  "can_view_reports",         default: false
    t.boolean  "can_update_sale_discount", default: false
    t.boolean  "can_remove_sales",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id"
    t.string   "role"
    t.string   "locale"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
