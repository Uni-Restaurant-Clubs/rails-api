# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_13_170044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "geocoded_address"
    t.string "instructions"
    t.string "apt_suite_number"
    t.string "street_number"
    t.string "street_name"
    t.integer "street_type"
    t.integer "city"
    t.integer "state"
    t.integer "country"
    t.string "zipcode"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city"], name: "index_addresses_on_city"
    t.index ["country"], name: "index_addresses_on_country"
    t.index ["street_type"], name: "index_addresses_on_street_type"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "address_id"
    t.text "manager_info"
    t.string "primary_phone_number"
    t.string "primary_email"
    t.text "other_contact_info"
    t.text "managers"
    t.integer "status", default: 0
    t.text "notes"
    t.datetime "scheduled_review_date_and_time"
    t.string "website_url"
    t.string "google_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_restaurants_on_address_id"
    t.index ["status"], name: "index_restaurants_on_status"
  end

end
