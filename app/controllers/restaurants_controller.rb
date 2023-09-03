class RestaurantsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  skip_before_action :require_login, only: %i[index show search address_search]
  # before_action :set_google_client
  before_action :set_restaurant, only: [:tags, :add_tag, :remove_tag, :update_tags]

  def index
  end

  def show
    @restaurant = Restaurant.find(params[:id]).decorate
  end

  def search
    restaurants_array = RestaurantDecorator.decorate_collection(fetch_restaurants)
    @restaurants = Kaminari.paginate_array(restaurants_array).page(params[:page])
  end

  def address_search
    restaurants_array = RestaurantDecorator.decorate_collection(fetch_restaurants_from_address)
    @restaurants = Kaminari.paginate_array(restaurants_array).page(params[:page])
  end

  # def new_tags; end

  # def edit_tags; end

  def tags
  end

  def add_tag
    @restaurant.tag_list.add(params[:tag_name])
    @restaurant.save
  end

  def remove_tag
    @restaurant.tag_list.remove(params[:tag_name])
    @restaurant.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @restaurant }
    end
  end

  def update_tags
    @restaurant.tag_list = params[:restaurant][:tag_list]
    @restaurant.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @restaurant }
    end
  end

  def bookmarks
    bookmark_restaurants = current_user.bookmark_restaurants.order(created_at: :desc).page(params[:page])
    @bookmark_restaurants = bookmark_restaurants.decorate
    @paginated_bookmarks = bookmark_restaurants
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def search_params
    params.permit(:radius, :place_type, :rating, :latitude, :longitude, :address)
  end

  def find_or_create_restaurant(place_data)
    Restaurant.find_or_create_from_api_data(place_data)
  end


  def fetch_restaurants
    if params[:latitude] && params[:longitude]
      location = "#{params[:latitude]},#{params[:longitude]}"
      # 現在地から取得の場合は現在営業中の店舗のみを検索
      fetch_places_from_api(location, opennow: true)
    else
      return []
    end
  end

  def fetch_restaurants_from_address
    location = Geocoder.search(params[:address]).first if params[:address].present?

    if location.nil? || location.latitude.nil? || location.longitude.nil?
      return []
    end

    fetch_places_from_api("#{location.latitude},#{location.longitude}")
  end


  def fetch_places_from_api(location, options = {})
    base_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    parameters = {
      location: location,
      radius: search_params[:radius] || 50,
      type: search_params[:place_type],
      key: ENV['GOOGLE_API_KEY'],
      language: 'ja'
    }.merge(options)

    url = base_url + parameters.to_query
    response = Net::HTTP.get(URI(url))
    results = JSON.parse(response)["results"]

    restaurants = results.map { |place_data| find_or_create_restaurant(place_data) }
    if search_params[:rating].present?
      restaurants.select! { |restaurant| restaurant.rating && restaurant.rating >= search_params[:rating].to_f }
    end
    restaurants
  end

end
