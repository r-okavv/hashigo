class RestaurantsController < ApplicationController
  def index
    @address = params[:address]
    @restaurants = fetch_nearby_restaurants(@address)
  end

  private

  def fetch_nearby_restaurants(address)
    places_client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])

    # 住所を緯度経度に変換
    result = Geocoder.search(address).first
    latitude = result&.latitude
    longitude = result&.longitude

    if latitude && longitude
      # Google Places APIにリクエストして飲食店情報を取得
      places_client.spots(latitude, longitude, types: ['restaurant'], radius: 50)
    else
      [] # 変換できなかった場合は空の配列を返す
    end
  end
end
