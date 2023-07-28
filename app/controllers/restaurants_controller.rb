class RestaurantsController < ApplicationController
  def index
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    
    if params[:address].present?
      location = Geocoder.search(params[:address]).first
      if location
        @restaurants = @client.spots(location.latitude, location.longitude, radius: 50, types: ['restaurant']).first(20)
      else
        @restaurants = []
      end
    elsif params[:latitude].present? && params[:longitude].present?
      # Todo: paramsで直接parameterを渡さないよう処理する
      @restaurants = @client.spots(params[:latitude], params[:longitude], radius: 100, types: ['restaurant']).first(20)
    else
      @restaurants = []
    end
  end
end
