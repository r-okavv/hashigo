class AddDetailColumnsToRestaurants < ActiveRecord::Migration[7.0]
  def change
    Restaurant.destroy_all

    add_column :restaurants, :editorial_summary, :text
    add_column :restaurants, :serves_beer, :boolean, default: false
    add_column :restaurants, :serves_wine, :boolean, default: false
  end
end
