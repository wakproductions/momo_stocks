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

ActiveRecord::Schema.define(version: 20170516155615) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "report_line_items", force: :cascade do |t|
    t.integer "report_snapshot_id"
    t.string "symbol"
    t.float "last_trade"
    t.float "change_percent"
    t.float "volume"
    t.float "volume_average"
    t.float "volume_ratio"
    t.float "short_days_to_cover"
    t.float "short_percent_of_float"
    t.float "float"
    t.float "float_percent_traded"
    t.float "institutional_ownership_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "volume_average_premarket"
    t.float "volume_ratio_premarket"
  end

  create_table "report_snapshots", force: :cascade do |t|
    t.datetime "built_at"
    t.integer "report_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "short_interest_as_of"
    t.date "institutional_ownership_as_of"
    t.date "report_date"
  end

end
