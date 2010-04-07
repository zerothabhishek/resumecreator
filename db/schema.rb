# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100325203759) do

  create_table "achievements", :force => true do |t|
    t.text     "achievements_text"
    t.integer  "resume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.text     "address"
    t.string   "phone_nos"
    t.string   "emails"
    t.integer  "resume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations", :force => true do |t|
    t.string   "level"
    t.string   "major"
    t.string   "score"
    t.string   "college"
    t.text     "more_info"
    t.integer  "resume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiences", :force => true do |t|
    t.string   "title"
    t.string   "company"
    t.string   "duration"
    t.text     "role"
    t.text     "more_info"
    t.integer  "resume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hobbies", :force => true do |t|
    t.text     "hobbies_text"
    t.integer  "resume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.text     "profile_text"
    t.integer  "resume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resumes", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "public_status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "meta_desc"
    t.integer  "rtemplate_id",  :default => 1
    t.datetime "pdf_timestamp"
  end

  create_table "rhelps", :force => true do |t|
    t.string   "rcontroller"
    t.string   "raction"
    t.string   "rview"
    t.string   "key"
    t.text     "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rtemplates", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "author"
    t.string   "location"
    t.string   "thumbnail_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.string   "skill_name"
    t.string   "skill_remarks"
    t.string   "skillset_type"
    t.integer  "resume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.string   "author"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_url"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.boolean  "logon_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_resume"
    t.string   "email_id"
  end

end
