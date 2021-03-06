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

ActiveRecord::Schema.define(version: 20171126140043) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airline_places", id: :serial, force: :cascade do |t|
    t.integer "airline_id"
    t.integer "place_id"
  end

  create_table "airlines", id: :serial, force: :cascade do |t|
    t.string "name"
    t.decimal "price_coef"
  end

  create_table "availabilities", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.integer "amount"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "cheques", id: :serial, force: :cascade do |t|
    t.integer "ticket_id"
  end

  create_table "deliveries", id: :serial, force: :cascade do |t|
    t.integer "provider_id"
    t.integer "product_id"
    t.decimal "price"
    t.integer "amount"
    t.date "delivery_date"
  end

  create_table "places", id: :serial, force: :cascade do |t|
    t.string "name"
    t.decimal "price"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "category_id"
    t.date "made"
    t.integer "expiration"
    t.decimal "price"
  end

  create_table "providers", id: :serial, force: :cascade do |t|
    t.string "address"
    t.string "phone"
  end

  create_table "seat_types", id: :serial, force: :cascade do |t|
    t.integer "airline_id"
    t.string "name"
    t.decimal "price_coef"
  end

  create_table "tickets", id: :serial, force: :cascade do |t|
    t.integer "place_id"
    t.integer "airline_id"
    t.integer "seat_type_id"
    t.decimal "price"
    t.integer "days_amount"
    t.date "start_date"
    t.integer "people_amount"
  end

end
