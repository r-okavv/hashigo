class RestaurantsController < ApplicationController
  def index
  end

  def search
    if params[:address].present?
      latitude, longitude = geocode_address(params[:address])
    elsif params[:latitude].present? && params[:longitude].present?
      latitude = params[:latitude].to_f
      longitude = params[:longitude].to_f
    else
      return
    end

    # 周辺の飲食店情報を取得
    radius = 50 # 50m radius for nearby places
    places = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY']).spots(latitude, longitude, radius: radius, types: 'restaurant')

    @restaurants = places
    # 緯度経度と周辺の飲食店情報をJavaScriptで取得可能にする
    gon.latitude = latitude
    gon.longitude = longitude
  end

  private

  def geocode_address(address)
    results = Geocoder.search(address)
    latitude = results.first&.latitude
    longitude = results.first&.longitude
    [latitude, longitude]
  end
end
