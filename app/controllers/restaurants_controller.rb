class RestaurantsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  skip_before_action :require_login, only: %i[index show search address_search]
  before_action :set_restaurant, only: %i[update_tag]

  def index
  end

  def show
    @restaurant = Restaurant.includes(:tags).find(params[:id]).decorate
  end

  def search
    if params[:address].present?
      restaurants_array = RestaurantDecorator.decorate_collection(fetch_restaurants)
      @restaurants = Kaminari.paginate_array(restaurants_array).page(params[:page])
    end
  end

  def bookmarks
    bookmark_restaurants = current_user.bookmark_restaurants.order(created_at: :desc).page(params[:page])
    @bookmark_restaurants = bookmark_restaurants.decorate
    @paginated_bookmarks = bookmark_restaurants
  end

  def update_tag
    @restaurant.tag_list = params[:restaurant][:tag_list]
    if @restaurant.save
      redirect_to restaurant_path(@restaurant)
    else
      flash[:error] = t('.fail')
      redirect_to @restaurant
    end
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
    location = if params[:latitude] && params[:longitude].present?
                 { latitude: params[:latitude], longitude: params[:longitude] }
              elsif params[:address]
                 geo_result = Geocoder.search(params[:address]).first
                 unless geo_result&.latitude && geo_result&.longitude
                   flash[:error] = t('.fail')
                   return []
                 end
                 { latitude: geo_result.latitude, longitude: geo_result.longitude }
               end
  
    if location && location[:latitude] && location[:longitude]
      options = {}
      binding.pry
      options[:opennow] = true if params[:open_now] == 'true'
      fetch_places_from_api("#{location[:latitude]},#{location[:longitude]}", options)
    else
      []
    end
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
