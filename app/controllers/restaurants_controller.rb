class RestaurantsController < ApplicationController
  def index
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    radius = params[:radius] || 50
    # options = {radius: radius.to_i, types: params[:place_type],min_rating: params[:rating],closing_time: params[:closing_time]}
    options = {language: 'ja', radius: radius.to_i, types: params[:place_type],min_rating: params[:rating],closing_time: params[:closing_time], detail:true}
    # Todo: 日本語データのみ取得できるようにする。

    if params[:latitude].present? && params[:longitude].present?
      places_data = @client.spots(params[:latitude], params[:longitude], options).first(20)
    elsif params[:address].present?
      location = Geocoder.search(params[:address]).first
      if location
        binding.pry
        places_data = @client.spots(location.latitude, location.longitude, options).first(20)
      else
        places_data = []
      end
    else
      places_data = []
    end

    @restaurants = places_data.map do |place_data|
      restaurant = Restaurant.find_or_initialize_by(place_id: place_data.place_id)
      unless restaurant.persisted?
        if place_data.photos.present?
          photo = place_data.photos.first
          photo_url = @client.spot_photo_url(photo.photo_reference, maxwidth: 400, maxheight: 300)
        end
        
        restaurant.attributes = {
          place_id: place_data.place_id,
          name: place_data.name,
          latitude: place_data.lat,
          longitude: place_data.lng,
          address: place_data.formatted_address,
          rating: place_data.rating,
          phone_number: place_data.formatted_phone_number,
          # opening_hours: place_data.opening_hours.to_s,
          # categories: place_data.types
          # price_level: restaurant.price_level →カラムを追加する必要あり
          # 画像表示に必要な情報
          # photo_reference: places_data[0].photos.first.photo_reference
          # html_attributions: places_data[0].photos.first.html_attributions
        }
        restaurant.save
      end
      restaurant
    end

  end

  private
  def restaurant_params
    params.permit(:name, :latitude, :longitude, :keyword, :radius, categories: [])
  end

end
