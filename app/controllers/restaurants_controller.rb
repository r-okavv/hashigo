class RestaurantsController < ApplicationController
  def index
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    radius = params[:radius] || 50
    # options = {radius: radius.to_i, types: params[:place_type],min_rating: params[:rating],closing_time: params[:closing_time]}
    options = {radius: radius.to_i, types: params[:place_type],min_rating: params[:rating],closing_time: params[:closing_time]}

    if params[:latitude].present? && params[:longitude].present?
      @restaurants = @client.spots(params[:latitude], params[:longitude], options).first(20)
    elsif params[:address].present?
      location = Geocoder.search(params[:address]).first
      if location
        @restaurants = @client.spots(location.latitude, location.longitude,options).first(20)
      else
        @restaurants = []
      end
    else
      @restaurants = []
    end
  end
end
