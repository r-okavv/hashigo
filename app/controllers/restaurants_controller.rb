class RestaurantsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  skip_before_action :require_login, only: %i[index show]
  # before_action :set_google_client
  before_action :set_restaurant, only: [:tags, :add_tag, :remove_tag, :update_tags]

  def index
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def search
    @restaurants = fetch_restaurants
  end

  def address_search
    @restaurants = fetch_restaurants_from_addess
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
    @bookmark_restaurants = current_user.bookmark_restaurants.order(created_at: :desc)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  # def set_google_client
  #   @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
  # end

  def search_params
    params.permit(:radius, :place_type, :rating, :closing_time, :latitude, :longitude, :address)
  end

  def find_or_create_restaurant(place_data)
    Restaurant.find_or_create_from_api_data(place_data)
  end

  # def fetch_restaurants
  #   places_data = if params[:latitude].present? && params[:longitude].present?
  #                   @client.spots(params[:latitude], params[:longitude], search_options).first(20)
  #                 else
  #                   []
  #                 end

  #   @restaurants = places_data.map { |place_data| find_or_create_restaurant(place_data) }

  #   # rating パラメータが存在する場合、その値以上の評価を持つレストランのみをフィルタリング
  #   if search_params[:rating].present?
  #     @restaurants = @restaurants.select { |restaurant| restaurant.rating && restaurant.rating >= search_params[:rating].to_f }
  #   end

  #   @restaurants
  # end

  def fetch_restaurants
    # NearBySearchのエンドポイントURL
    base_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
  
    # リクエストのパラメータを設定
    parameters = {
      location: "#{params[:latitude]},#{params[:longitude]}",
      radius: search_params[:radius] || 50,
      type: search_params[:place_type],
      key: ENV['GOOGLE_API_KEY'],
      language: 'ja'
    }
  
    # パラメータをURLにエンコードして結合
    url = base_url + parameters.to_query
  
    # HTTPリクエストを行い、レスポンスを取得
    response = Net::HTTP.get(URI(url))
    results = JSON.parse(response)["results"]
  
    # レスポンスからレストランのデータを取得または作成
    @restaurants = results.map { |place_data| find_or_create_restaurant(place_data) }
  
    # rating パラメータが存在する場合、その値以上の評価を持つレストランのみをフィルタリング
    if search_params[:rating].present?
      @restaurants = @restaurants.select { |restaurant| restaurant.rating && restaurant.rating >= search_params[:rating].to_f }
    end
  
    @restaurants
  end

  def fetch_restaurants_from_addess
    places_data = if params[:address].present?
                    location = Geocoder.search(params[:address]).first
                    location ? @client.spots(location.latitude, location.longitude, search_options).first(20) : []
                  else
                    []
                  end

    @restaurants = places_data.map { |place_data| find_or_create_restaurant(place_data) }

    if search_params[:rating].present?
      @restaurants = @restaurants.select { |restaurant| restaurant.rating && restaurant.rating >= search_params[:rating].to_f }
    end

    @restaurants
  end

  # def search_options
  #   radius = params[:radius] || 50
  #   {
  #     language: 'ja',
  #     radius: radius.to_i,
  #     types: params[:place_type],
  #     closing_time: params[:closing_time],
  #     detail: true
  #   }
  # end

  # def search_params
  #   params.permit(:radius, :place_type, :rating, :closing_time, :latitude, :longitude, :address)
  # end

end
