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

ActiveRecord::Schema[8.0].define(version: 2025_07_18_112822) do
  create_table "owners", force: :cascade do |t|
    t.string "name", limit: 200, null: false
    t.string "email", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
  end

  create_table "pets", force: :cascade do |t|
    t.integer "species_id", null: false
    t.integer "owner_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_pets_on_owner_id"
    t.index ["species_id"], name: "index_pets_on_species_id"
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_species_on_name", unique: true
  end

  create_table "tracker_types", force: :cascade do |t|
    t.integer "species_id", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["species_id", "category"], name: "index_tracker_types_on_species_id_and_category", unique: true
    t.index ["species_id"], name: "index_tracker_types_on_species_id"
  end

  create_table "trackers", force: :cascade do |t|
    t.integer "pet_id", null: false
    t.integer "tracker_type_id", null: false
    t.boolean "lost_tracker", default: false
    t.boolean "in_zone", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_trackers_on_pet_id"
    t.index ["tracker_type_id"], name: "index_trackers_on_tracker_type_id"
  end

  add_foreign_key "pets", "owners"
  add_foreign_key "pets", "species"
  add_foreign_key "tracker_types", "species"
  add_foreign_key "trackers", "pets"
  add_foreign_key "trackers", "tracker_types"
end
