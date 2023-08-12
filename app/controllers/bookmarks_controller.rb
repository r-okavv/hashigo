class BookmarksController < ApplicationController
    def create
        restaurant = Restaurant.find(params[:restaurant_id])
        current_user.bookmark(restaurant)
        redirect_back fallback_location: root_path
      end

      def destroy
        restaurant = current_user.bookmarks.find(params[:id]).restaurant
        current_user.unbookmark(restaurant)
        redirect_back fallback_location: root_path
      end
end
