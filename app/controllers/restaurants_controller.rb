class RestaurantsController < ApplicationController
  def index
    # @address = params[:address]
    # @restaurants = fetch_nearby_restaurants(@address)
    if params[:address].present? && params[:address] != '現在地'
      @address = params[:address]
      @latitude, @longitude = fetch_coordinates(@address)
    else
      @address = '現在地'
      @latitude, @longitude = fetch_current_location

    if @latitude && @longitude
      # 住所から店舗情報を取得
      @restaurants = fetch_nearby_restaurants(@latitude, @longitude)
    elsif params[:current_location].present?
      # 現在地から店舗情報を取得
      @latitude, @longitude = fetch_current_location
      @restaurants = fetch_nearby_restaurants(@latitude, @longitude)
    else
      @restaurants = []
  end

  private

  def fetch_nearby_restaurants(latitude, longitude)
    places_client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])

    # 住所を緯度経度に変換
    result = Geocoder.search(address).first
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

  # 現在地を取得して返す
  def fetch_current_location
    if request.location.present?
      [request.location.latitude, request.location.longitude]
    else
      # TODO：現在地取得に失敗した場合の対応を追加する
      nil
    end
  end
end
