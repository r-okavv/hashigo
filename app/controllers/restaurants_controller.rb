class RestaurantsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_google_client

  def index
    @restaurants = fetch_restaurants
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end


  def bookmarks
    @bookmark_restaurants = current_user.bookmark_restaurants.order(created_at: :desc)
  end

  private

  def set_google_client
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
  end

  def search_params
    params.permit(:radius, :place_type, :rating, :closing_time, :latitude, :longitude, :address)
  end

  def find_or_create_restaurant(place_data)
    Restaurant.find_or_create_from_api_data(place_data)
  end

  def fetch_restaurants
    places_data = if params[:latitude].present? && params[:longitude].present?
                    @client.spots(params[:latitude], params[:longitude], search_options).first(20)
                  elsif params[:address].present?
                    location = Geocoder.search(params[:address]).first
                    location ? @client.spots(location.latitude, location.longitude, search_options).first(20) : []
                  else
                    []
                  end

    places_data.map { |place_data| find_or_create_restaurant(place_data) }
  end

  def search_options
    radius = params[:radius] || 50
    {
      language: 'ja',
      radius: radius.to_i,
      types: params[:place_type],
      closing_time: params[:closing_time],
      detail: true
    }
  end

  def search_params
    params.permit(:radius, :place_type, :rating, :closing_time, :latitude, :longitude, :address)
  end

end
