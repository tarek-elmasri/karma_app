# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_26_072116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charged_people", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name", null: false
    t.integer "phone", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.index ["client_id"], name: "index_charged_people_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "area", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "invoices_count", default: 0
    t.float "sales", default: 0.0
    t.float "remaining_balance", default: 0.0
    t.float "paid", default: 0.0
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.integer "number", null: false
    t.float "value", null: false
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "paid", default: 0.0
    t.index ["client_id"], name: "index_invoices_on_client_id"
  end

  create_table "payments", force: :cascade do |t|
    t.float "amount", null: false
    t.bigint "invoice_id", null: false
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "payment_method", null: false
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  add_foreign_key "charged_people", "clients"
  add_foreign_key "invoices", "clients"
  add_foreign_key "payments", "invoices"
end
