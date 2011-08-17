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

ActiveRecord::Schema.define(:version => 20110817230706) do

  create_table "countries", :force => true do |t|
    t.string    "currency"
    t.string    "country"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.float     "to_usd_rate"
  end

  create_table "plans", :force => true do |t|
    t.string    "name"
    t.float     "cost"
    t.float     "usage"
    t.float     "day"
    t.float     "night"
    t.string    "description"
    t.float     "overage"
    t.string    "speed_unit"
    t.float     "highcost"
    t.string    "highproduct"
    t.float     "lowcost"
    t.string    "lowproduct"
    t.float     "speed"
    t.float     "tax"
    t.integer   "provider_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "usage_unit"
    t.string    "day_usage_unit"
    t.string    "night_usage_unit"
    t.string    "incremental_unit"
    t.string    "plan_type"
    t.float     "installation"
  end

  create_table "providers", :force => true do |t|
    t.string    "name"
    t.string    "provider_type"
    t.integer   "country_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.float     "highcost"
    t.string    "highproduct"
    t.float     "lowcost"
    t.string    "lowproduct"
  end

  create_table "usage_levels", :force => true do |t|
    t.string    "name"
    t.string    "unit"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.decimal   "amount"
  end

  create_table "users", :force => true do |t|
    t.string    "username"
    t.string    "password"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "country_id"
  end

end
