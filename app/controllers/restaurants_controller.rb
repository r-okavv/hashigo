class RestaurantsController < ApplicationController
  def index
    # @address = params[:address]
    # @restaurants = fetch_nearby_restaurants(@address)
    if params[:current_location].present?
      binding.pry
      # 現在地から店舗情報を取得
      @latitude = params[:latitude].to_f
      @longitude = params[:longitude].to_f
    elsif params[:address].present?
      # 入力された住所から店舗情報を取得
      binding.pry
      @address = params[:address]
      @latitude, @longitude = fetch_coordinates(@address)
    end

    if @latitude && @longitude
      # 住所から店舗情報を取得
      @restaurants = fetch_nearby_restaurants(@latitude, @longitude)
    else
      @restaurants = []
    end
  end

  private

  def fetch_nearby_restaurants(latitude, longitude)
    places_client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    places_client.spots(latitude, longitude, types: ['restaurant'], radius: 50)

    # latitude = result&.latitude
    # longitude = result&.longitude

    # if latitude && longitude
    #   # Google Places APIにリクエストして飲食店情報を取得
    #   places_client.spots(latitude, longitude, types: ['restaurant'], radius: 50)
    # else
    #   [] # 変換できなかった場合は空の配列を返す
    # end
  end

  # 住所を緯度経度に変換し返す
  def fetch_coordinates(address)
    result = Geocoder.search(address).first
    [result&.latitude, result&.longitude]
  end
end
