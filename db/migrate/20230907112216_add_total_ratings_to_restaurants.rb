class AddTotalRatingsToRestaurants < ActiveRecord::Migration[7.0]
  def change
    Restaurant.destroy_all

    add_column :restaurants, :total_ratings, :integer, default: 0
  end
end
