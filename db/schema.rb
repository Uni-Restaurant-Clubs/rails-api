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

ActiveRecord::Schema.define(version: 2021_07_31_165142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "geocoded_address"
    t.string "instructions"
    t.string "apt_suite_number"
    t.string "street_number"
    t.string "street_name"
    t.string "address_1"
    t.string "address_2"
    t.string "address_3"
    t.integer "street_type"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zipcode"
    t.float "latitude"
    t.float "longitude"
    t.integer "restaurant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city"], name: "index_addresses_on_city"
    t.index ["country"], name: "index_addresses_on_country"
    t.index ["restaurant_id"], name: "index_addresses_on_restaurant_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.string "title"
    t.integer "photographer_id"
    t.integer "review_id"
    t.integer "restaurant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["photographer_id"], name: "index_images_on_photographer_id"
    t.index ["restaurant_id"], name: "index_images_on_restaurant_id"
    t.index ["review_id"], name: "index_images_on_review_id"
  end

  create_table "photographers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "drive_folder_url"
    t.integer "university_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["university_id"], name: "index_photographers_on_university_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "yelp_id"
    t.string "yelp_alias"
    t.string "image_url"
    t.string "yelp_url"
    t.string "primary_phone_number"
    t.string "primary_email"
    t.text "manager_info"
    t.integer "operational_status"
    t.text "other_contact_info"
    t.integer "status", default: 0
    t.text "notes"
    t.datetime "scheduled_review_date_and_time"
    t.string "website_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_franchise", default: false
    t.boolean "starred", default: false
    t.integer "urc_rating", default: 0
    t.float "yelp_rating"
    t.bigint "yelp_review_count", default: 0
    t.integer "follow_up_reason"
    t.index ["follow_up_reason"], name: "index_restaurants_on_follow_up_reason"
    t.index ["is_franchise"], name: "index_restaurants_on_is_franchise"
    t.index ["operational_status"], name: "index_restaurants_on_operational_status"
    t.index ["starred"], name: "index_restaurants_on_starred"
    t.index ["status"], name: "index_restaurants_on_status"
    t.index ["urc_rating"], name: "index_restaurants_on_urc_rating"
    t.index ["yelp_id"], name: "index_restaurants_on_yelp_id", unique: true
    t.index ["yelp_rating"], name: "index_restaurants_on_yelp_rating"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "restaurant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restaurant_id"], name: "index_reviews_on_restaurant_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "last_used"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.integer "school_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["school_type"], name: "index_universities_on_school_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_confirm_email_token"
    t.datetime "reset_password_confirm_email_token_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirm_uni_email_token"
    t.datetime "uni_email_confirmed_at"
    t.string "uni_email"
    t.string "pending_uni_email"
    t.datetime "confirm_uni_email_sent_at"
    t.string "stripe_customer_id"
    t.index ["confirm_uni_email_token"], name: "index_users_on_confirm_uni_email_token"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"
  end

  create_table "writers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "drive_folder_url"
    t.integer "university_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["university_id"], name: "index_writers_on_university_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
