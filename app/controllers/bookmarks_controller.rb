class BookmarksController < ApplicationController
  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    current_user.bookmark(@restaurant)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def destroy
    @restaurant = current_user.bookmarks.find(params[:id]).restaurant
    current_user.unbookmark(@restaurant)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end
end
