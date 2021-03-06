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

ActiveRecord::Schema.define(version: 2020_04_07_212842) do

  create_table "admins", force: :cascade do |t|
    t.string "fname"
    t.string "mname"
    t.string "lname"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", force: :cascade do |t|
    t.string "code"
    t.string "email"
    t.string "firstname"
    t.string "middlename"
    t.string "lastname"
    t.string "preferredname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards_courses", force: :cascade do |t|
    t.integer "card_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_cards_courses_on_card_id"
    t.index ["course_id"], name: "index_cards_courses_on_course_id"
  end

  create_table "cards_days", force: :cascade do |t|
    t.integer "card_id"
    t.integer "day_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_cards_days_on_card_id"
    t.index ["day_id"], name: "index_cards_days_on_day_id"
  end

  create_table "courses", force: :cascade do |t|
    t.integer "teacher_id"
    t.string "name"
    t.integer "number"
    t.integer "section"
    t.integer "year"
    t.string "season"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "courses_students", force: :cascade do |t|
    t.integer "student_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_courses_students_on_course_id"
    t.index ["student_id"], name: "index_courses_students_on_student_id"
  end

  create_table "days", force: :cascade do |t|
    t.integer "course_id"
    t.string "classday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_days_on_course_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "fname"
    t.string "mname"
    t.string "lname"
    t.string "prefname"
    t.integer "uin"
    t.string "email"
    t.binary "picture"
    t.string "card_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "google_token"
    t.string "google_refresh_token"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "fname"
    t.string "mname"
    t.string "lname"
    t.string "email"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
