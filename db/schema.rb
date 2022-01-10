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

ActiveRecord::Schema.define(version: 2022_01_09_215809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
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

  create_table "check_ins", force: :cascade do |t|
    t.string "latitude"
    t.string "longitude"
    t.integer "restaurant_id"
    t.integer "feature_period_id"
    t.boolean "user_is_at_restaurant", default: false
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feature_period_id"], name: "index_check_ins_on_feature_period_id"
    t.index ["restaurant_id"], name: "index_check_ins_on_restaurant_id"
    t.index ["user_id"], name: "index_check_ins_on_user_id"
    t.index ["user_is_at_restaurant"], name: "index_check_ins_on_user_is_at_restaurant"
  end

  create_table "content_creators", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "public_unique_username"
    t.string "email"
    t.string "phone"
    t.string "linkedin_url"
    t.string "facebook_url"
    t.string "instagram_url"
    t.string "website_url"
    t.text "bio"
    t.string "drive_folder_url"
    t.integer "university_id"
    t.integer "creator_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "location_code_id"
    t.string "youtube_url"
    t.boolean "is_writer", default: false
    t.boolean "is_photographer", default: false
    t.boolean "is_videographer", default: false
    t.text "intro_application_text"
    t.text "experiences_application_text"
    t.text "why_join_application_text"
    t.text "application_social_media_links"
    t.integer "status"
    t.boolean "applied_for_writer", default: false
    t.boolean "applied_for_photographer", default: false
    t.boolean "applied_for_videographer", default: false
    t.text "food_preferences"
    t.text "camera_equipment_description"
    t.string "editing_software"
    t.text "notes"
    t.string "allergies"
    t.index ["applied_for_photographer"], name: "index_content_creators_on_applied_for_photographer"
    t.index ["applied_for_videographer"], name: "index_content_creators_on_applied_for_videographer"
    t.index ["applied_for_writer"], name: "index_content_creators_on_applied_for_writer"
    t.index ["creator_type"], name: "index_content_creators_on_creator_type"
    t.index ["email"], name: "index_content_creators_on_email", unique: true
    t.index ["is_photographer"], name: "index_content_creators_on_is_photographer"
    t.index ["is_videographer"], name: "index_content_creators_on_is_videographer"
    t.index ["is_writer"], name: "index_content_creators_on_is_writer"
    t.index ["location_code_id"], name: "index_content_creators_on_location_code_id"
    t.index ["public_unique_username"], name: "index_content_creators_on_public_unique_username", unique: true
    t.index ["status"], name: "index_content_creators_on_status"
    t.index ["university_id"], name: "index_content_creators_on_university_id"
  end

  create_table "creator_review_offers", force: :cascade do |t|
    t.datetime "responded_at"
    t.boolean "option_one_response"
    t.datetime "option_one"
    t.datetime "option_two"
    t.boolean "option_two_response"
    t.datetime "option_three"
    t.boolean "option_three_response"
    t.boolean "not_available_for_any_options"
    t.boolean "does_not_want_to_review_this_restaurant"
    t.text "does_not_want_to_review_reason"
    t.integer "restaurant_id"
    t.integer "content_creator_id"
    t.boolean "as_writer", default: false
    t.boolean "as_photographer", default: false
    t.boolean "as_videographer", default: false
    t.string "token"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["as_photographer"], name: "index_creator_review_offers_on_as_photographer"
    t.index ["as_videographer"], name: "index_creator_review_offers_on_as_videographer"
    t.index ["as_writer"], name: "index_creator_review_offers_on_as_writer"
    t.index ["content_creator_id"], name: "index_creator_review_offers_on_content_creator_id"
    t.index ["restaurant_id"], name: "index_creator_review_offers_on_restaurant_id"
    t.index ["token"], name: "index_creator_review_offers_on_token", unique: true
  end

  create_table "feature_periods", force: :cascade do |t|
    t.integer "discount_type"
    t.integer "discount_number"
    t.integer "status"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "disclaimers"
    t.text "perks"
    t.text "notes"
    t.integer "restaurant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discount_type"], name: "index_feature_periods_on_discount_type"
    t.index ["restaurant_id"], name: "index_feature_periods_on_restaurant_id"
    t.index ["status"], name: "index_feature_periods_on_status"
  end

  create_table "identities", force: :cascade do |t|
    t.integer "user_id"
    t.text "external_user_id"
    t.integer "provider"
    t.string "email"
    t.boolean "verified_email"
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "picture"
    t.string "locale"
    t.text "access_token"
    t.datetime "expires_at"
    t.text "refresh_token"
    t.text "scope"
    t.string "token_type"
    t.text "id_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_identities_on_email"
    t.index ["provider", "external_user_id"], name: "index_identities_on_provider_and_external_user_id", unique: true
    t.index ["provider"], name: "index_identities_on_provider"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "title"
    t.boolean "featured", default: false
    t.integer "review_id"
    t.integer "writer_id"
    t.integer "photographer_id"
    t.integer "image_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "content_creator_id"
    t.index ["content_creator_id"], name: "index_images_on_content_creator_id"
    t.index ["featured"], name: "index_images_on_featured"
    t.index ["image_type"], name: "index_images_on_image_type"
    t.index ["photographer_id"], name: "index_images_on_photographer_id"
    t.index ["review_id"], name: "index_images_on_review_id"
    t.index ["writer_id"], name: "index_images_on_writer_id"
  end

  create_table "location_codes", force: :cascade do |t|
    t.string "code"
    t.integer "state"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_location_codes_on_code", unique: true
    t.index ["state"], name: "index_location_codes_on_state"
  end

  create_table "log_events", force: :cascade do |t|
    t.integer "user_id"
    t.integer "restaurant_id"
    t.integer "content_creator_id"
    t.string "event_name"
    t.string "label"
    t.string "user_ip_address"
    t.integer "category"
    t.text "properties"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "feature_period_id"
    t.index ["category"], name: "index_log_events_on_category"
    t.index ["content_creator_id"], name: "index_log_events_on_content_creator_id"
    t.index ["event_name"], name: "index_log_events_on_event_name"
    t.index ["feature_period_id"], name: "index_log_events_on_feature_period_id"
    t.index ["label"], name: "index_log_events_on_label"
    t.index ["restaurant_id"], name: "index_log_events_on_restaurant_id"
    t.index ["user_id"], name: "index_log_events_on_user_id"
    t.index ["user_ip_address"], name: "index_log_events_on_user_ip_address"
  end

  create_table "restaurant_categories", force: :cascade do |t|
    t.string "alias"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alias"], name: "index_restaurant_categories_on_alias"
  end

  create_table "restaurant_category_restaurants", force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "restaurant_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restaurant_category_id"], name: "index_restaurant_category_restaurants_on_restaurant_category_id"
    t.index ["restaurant_id"], name: "index_restaurant_category_restaurants_on_restaurant_id"
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
    t.datetime "accepted_at"
    t.datetime "option_1"
    t.datetime "option_2"
    t.datetime "option_3"
    t.boolean "initial_offer_sent_to_creators", default: false
    t.boolean "writer_confirmed", default: false
    t.boolean "photographer_confirmed", default: false
    t.boolean "restaurant_confirmed_final_time", default: false
    t.boolean "confirmed_with_restaurant_day_of_review", default: false
    t.boolean "confirmed_with_writer_day_of_review", default: false
    t.boolean "confirmed_with_photographer_day_of_review", default: false
    t.boolean "photographer_handed_in_photos", default: false
    t.datetime "date_photos_received"
    t.boolean "writer_handed_in_article", default: false
    t.datetime "date_article_received"
    t.integer "photographer_id"
    t.integer "writer_id"
    t.boolean "just_reviewed_emails_sent", default: false
    t.string "restaurant_event_id"
    t.string "restaurant_event_url"
    t.string "creators_event_id"
    t.string "creators_event_url"
    t.boolean "offer_sent_to_everyone", default: false
    t.boolean "initial_offers_sent_to_creators", default: false
    t.boolean "confirmed_with_restaurant_three_days_before", default: false
    t.boolean "confirmed_with_creators_day_before", default: false
    t.string "instagram_username"
    t.string "cellphone_number"
    t.integer "restaurant_replied_through"
    t.datetime "date_we_contacted_them"
    t.datetime "date_restaurant_replied"
    t.string "facebook_username"
    t.boolean "did_we_phone_them", default: false
    t.boolean "did_we_instagram_message_them", default: false
    t.boolean "did_we_facebook_message_them"
    t.boolean "did_we_email_them", default: false
    t.boolean "did_we_contact_them_through_website", default: false
    t.integer "contacted_by"
    t.integer "preferred_contact_method"
    t.index ["contacted_by"], name: "index_restaurants_on_contacted_by"
    t.index ["did_we_contact_them_through_website"], name: "index_restaurants_on_did_we_contact_them_through_website"
    t.index ["did_we_email_them"], name: "index_restaurants_on_did_we_email_them"
    t.index ["did_we_facebook_message_them"], name: "index_restaurants_on_did_we_facebook_message_them"
    t.index ["did_we_instagram_message_them"], name: "index_restaurants_on_did_we_instagram_message_them"
    t.index ["did_we_phone_them"], name: "index_restaurants_on_did_we_phone_them"
    t.index ["follow_up_reason"], name: "index_restaurants_on_follow_up_reason"
    t.index ["is_franchise"], name: "index_restaurants_on_is_franchise"
    t.index ["just_reviewed_emails_sent"], name: "index_restaurants_on_just_reviewed_emails_sent"
    t.index ["operational_status"], name: "index_restaurants_on_operational_status"
    t.index ["photographer_id"], name: "index_restaurants_on_photographer_id"
    t.index ["preferred_contact_method"], name: "index_restaurants_on_preferred_contact_method"
    t.index ["restaurant_replied_through"], name: "index_restaurants_on_restaurant_replied_through"
    t.index ["starred"], name: "index_restaurants_on_starred"
    t.index ["status"], name: "index_restaurants_on_status"
    t.index ["urc_rating"], name: "index_restaurants_on_urc_rating"
    t.index ["writer_id"], name: "index_restaurants_on_writer_id"
    t.index ["yelp_id"], name: "index_restaurants_on_yelp_id", unique: true
    t.index ["yelp_rating"], name: "index_restaurants_on_yelp_rating"
  end

  create_table "review_happened_confirmations", force: :cascade do |t|
    t.integer "content_creator_id"
    t.boolean "response"
    t.datetime "responded_at"
    t.integer "restaurant_id"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content_creator_id"], name: "index_review_happened_confirmations_on_content_creator_id"
    t.index ["response"], name: "index_review_happened_confirmations_on_response"
    t.index ["restaurant_id"], name: "index_review_happened_confirmations_on_restaurant_id"
    t.index ["token"], name: "index_review_happened_confirmations_on_token", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "reviewed_at"
    t.integer "writer_id"
    t.integer "photographer_id"
    t.integer "university_id"
    t.integer "restaurant_id"
    t.text "full_article"
    t.text "medium_article"
    t.text "small_article"
    t.string "article_title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.integer "quality_ranking", default: 1
    t.index ["photographer_id"], name: "index_reviews_on_photographer_id"
    t.index ["quality_ranking"], name: "index_reviews_on_quality_ranking"
    t.index ["restaurant_id"], name: "index_reviews_on_restaurant_id"
    t.index ["status"], name: "index_reviews_on_status"
    t.index ["university_id"], name: "index_reviews_on_university_id"
    t.index ["writer_id"], name: "index_reviews_on_writer_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "last_used"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "text_contents", force: :cascade do |t|
    t.text "text"
    t.integer "category"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category"], name: "index_text_contents_on_category"
    t.index ["name"], name: "index_text_contents_on_name"
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
    t.string "first_name"
    t.string "last_name"
    t.string "locale"
    t.string "passwordless_email_code"
    t.datetime "passwordless_email_code_sent_at"
    t.index ["confirm_uni_email_token"], name: "index_users_on_confirm_uni_email_token"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["passwordless_email_code"], name: "index_users_on_passwordless_email_code", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
