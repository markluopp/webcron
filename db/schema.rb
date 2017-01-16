# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170115140929) do

  create_table "histories", force: :cascade do |t|
    t.text     "log",            limit: 65535
    t.integer  "job_id",         limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "execution_time", limit: 4
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.string   "alert_email",  limit: 255
    t.string   "status",       limit: 255
    t.string   "progress",     limit: 255
    t.datetime "last_end_at"
    t.datetime "next_run_at"
    t.datetime "first_run_at"
    t.string   "frequency",    limit: 255
    t.integer  "pid",          limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "jobtype_id",   limit: 4
  end

  create_table "jobtypes", force: :cascade do |t|
    t.string   "jobtype_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "call_script",  limit: 255
  end

  create_table "parameter_options", force: :cascade do |t|
    t.string   "param_name", limit: 255
    t.text     "param_help", limit: 65535
    t.integer  "jobtype_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "parameters", force: :cascade do |t|
    t.string   "param_name",  limit: 255
    t.text     "param_value", limit: 65535
    t.integer  "job_id",      limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "jobtype_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 255
    t.string   "passwd",     limit: 255
    t.string   "user_type",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
