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

ActiveRecord::Schema.define(version: 20200506203012) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "overtime"
    t.datetime "work_end_time"
    t.text "job_description"
    t.text "instructor"
    t.string "tomorrow"
    t.boolean "next_day"
    t.boolean "day_after", default: false
    t.datetime "designated_work_end_time"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "office_name"
    t.integer "office_number"
    t.string "attendance_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "department"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "basic_time", default: "2020-05-03 23:00:00"
    t.datetime "work_time", default: "2020-05-03 22:30:00"
    t.datetime "designation_duty_start_time", default: "2020-05-03 23:00:00"
    t.datetime "designation_duty_finish_time", default: "2020-05-04 08:00:00"
    t.string "employee_number"
    t.string "card_id"
    t.boolean "superior1", default: false
    t.boolean "superior2", default: false
    t.string "affiliation"
    t.string "uid"
    t.string "basic_work_time"
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.string "password"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
