class RestaurantsController < ApplicationController
  def index
    radius = params[:radius] || 50
    # options = {radius: radius.to_i, types: params[:place_type],min_rating: params[:rating],closing_time: params[:closing_time]}
    options = {language: 'ja', radius: radius.to_i, types: params[:place_type],min_rating: params[:rating],closing_time: params[:closing_time], detail:true}
    # Todo: 日本語データのみ取得できるようにする。
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])

    if params[:latitude].present? && params[:longitude].present?
      places_data = @client.spots(params[:latitude], params[:longitude], options).first(20)
    elsif params[:address].present?
      location = Geocoder.search(params[:address]).first
      if location
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
          photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo.photo_reference}&key=#{ENV['GOOGLE_API_KEY']}"
          html_attributions = photo.html_attributions.first
        end

        restaurant.attributes = {
          place_id: place_data.place_id,
          name: place_data.name,
          latitude: place_data.lat,
          longitude: place_data.lng,
          address: place_data.formatted_address,
          rating: place_data.rating,
          phone_number: place_data.formatted_phone_number,
          categories: place_data.types,
          price_level: place_data.price_level,
          # image_url: place_data.photos.present? ? @client.spot_photo_url(reference: place_data.photos.first.photo_reference, maxwidth: 400) : nil,
          image_url: photo_url,
          # html_attributions: place_data.photos.first.html_attributions,
          html_attributions: html_attributions,
          url: place_data.url,
          opening_hours: place_data.opening_hours ? place_data.opening_hours["weekday_text"].join(", ") : "N/A"
        }
        restaurant.save
      end
      restaurant
    end

    def show
      @restaurant = Restaurant.find(params[:id])
    end

    def bookmarks
      @bookmark_restaurants = current_user.bookmark_boards.includes(:user).order(created_at: :desc)
    end

  end

  private
  def restaurant_params
    params.permit(:name, :latitude, :longitude, :keyword, :radius, categories: [])
  end

end
