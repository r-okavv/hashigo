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

ActiveRecord::Schema[7.0].define(version: 2023_11_01_144945) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_bookmarks_on_restaurant_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "questionnaire_restaurants", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "questionnaire_id", null: false
    t.index ["questionnaire_id", "restaurant_id"], name: "index_on_questionnaire_and_restaurant", unique: true
    t.index ["questionnaire_id"], name: "index_questionnaire_restaurants_on_questionnaire_id"
    t.index ["restaurant_id"], name: "index_questionnaire_restaurants_on_restaurant_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "questionnaire_restaurants_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["questionnaire_restaurants_id"], name: "index_questionnaires_on_questionnaire_restaurants_id"
    t.index ["user_id"], name: "index_questionnaires_on_user_id"
    t.index ["uuid"], name: "index_questionnaires_on_uuid"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "place_id", null: false
    t.string "name", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "address"
    t.float "rating"
    t.string "phone_number"
    t.string "opening_hours"
    t.string "categories", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "image_url"
    t.text "html_attributions"
    t.integer "price_level"
    t.integer "total_ratings", default: 0
    t.text "editorial_summary"
    t.boolean "serves_beer", default: false
    t.boolean "serves_wine", default: false
    t.index ["place_id"], name: "index_restaurants_on_place_id", unique: true
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "questionnaire_restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_restaurant_id"], name: "index_votes_on_questionnaire_restaurant_id"
  end

  add_foreign_key "bookmarks", "restaurants"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "questionnaire_restaurants", "questionnaires"
  add_foreign_key "questionnaire_restaurants", "restaurants"
  add_foreign_key "questionnaires", "questionnaire_restaurants", column: "questionnaire_restaurants_id"
  add_foreign_key "questionnaires", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "votes", "questionnaire_restaurants"
end
