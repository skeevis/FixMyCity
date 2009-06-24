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

ActiveRecord::Schema.define(:version => 20090622011958) do

  create_table "phone_callers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_requests", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "service_id"
    t.string   "service_code"
    t.string   "aid"
    t.text     "fields"
    t.string   "phone_number"
    t.string   "email"
    t.text     "description"
    t.text     "status"
    t.datetime "status_updated_at"
    t.boolean  "is_silenced",       :default => false
  end

end
