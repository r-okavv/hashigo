class RestaurantsController < ApplicationController
  def index
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    # binding.pry =>params[radius]はnil
    radius = params[:radius] || 50
    options = {radius: radius.to_i, types: ['restaurant']}

    if params[:address].present?
      location = Geocoder.search(params[:address]).first
      if location
        # @restaurants = @client.spots(location.latitude, location.longitude, @radius, types: ['restaurant']).first(20)
        @restaurants = @client.spots(location.latitude, location.longitude,options).first(20)
      else
        @restaurants = []
      end
    elsif params[:latitude].present? && params[:longitude].present?
      # Todo: paramsで直接parameterを渡さないよう処理する
      @restaurants = @client.spots(params[:latitude], params[:longitude], options).first(20)
    else
      @restaurants = []
    end
  end
end
