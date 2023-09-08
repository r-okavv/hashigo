class AddImageToRestaurants < ActiveRecord::Migration[7.0]
  def change
    Restaurant.destroy_all

    add_column :restaurants, :url, :string
    add_column :restaurants, :image_url, :string
    add_column :restaurants, :html_attributions, :text
    add_column :restaurants, :price_level, :integer
  end
end
