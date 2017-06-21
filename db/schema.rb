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

ActiveRecord::Schema.define(version: 20170621214750) do

  create_table "customers", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.datetime "injested_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["injested_at"], name: "index_customers_on_injested_at"
    t.index ["uuid"], name: "index_customers_on_uuid", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.string "customer_id", null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.float "amount"
    t.boolean "invoiced"
    t.string "invoice_error"
    t.index ["customer_id", "year", "month"], name: "index_invoices_on_customer_id_and_year_and_month", unique: true
  end

end
