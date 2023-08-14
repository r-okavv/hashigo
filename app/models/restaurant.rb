class Restaurant < ApplicationRecord
    validates :place_id, presence: true
    validates :name, presence: true
    validates :latitude, presence: true
    validates :longitude, presence: true

    def self.find_or_create_from_api_data(data)
        restaurant = find_or_initialize_by(place_id: data.place_id)
        return restaurant if restaurant.persisted?
    
        if data.photos.present?
          photo = data.photos.first
          photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo.photo_reference}&key=#{ENV['GOOGLE_API_KEY']}"
          html_attributions = photo.html_attributions.first
        end
        
        restaurant.attributes = {
            place_id: data.place_id,
            name: data.name,
            latitude: data.lat,
            longitude: data.lng,
            address: data.formatted_address,
            rating: data.rating,
            phone_number: data.formatted_phone_number,
            categories: data.types,
            price_level: data.price_level,
            image_url: photo_url,
            html_attributions: html_attributions,
            url: data.url,
            opening_hours: data.opening_hours ? data.opening_hours["weekday_text"].join(", ") : "N/A"
          }
        restaurant.save
        restaurant
      end
end
