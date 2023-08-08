class Restaurants < ActiveRecord::Migration[7.0]
  create_table :restaurants do |t|
    t.string :place_id, null: false
    t.string :name, null: false
    t.float :latitude, null: false
    t.float :longitude, null: false
    t.string :address
    t.float :rating
    t.string :phone_number
    t.string :opening_hours
    t.string :categories, array: true, default: []
  
    t.timestamps
  end
  add_index :restaurants, :place_id, unique: true
end
