class Restaurant < ApplicationRecord
  acts_as_taggable_on :tags
  has_many :bookmarks, dependent: :destroy
  validates :place_id, presence: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  def self.find_or_create_from_api_data(data)
    restaurant = find_or_initialize_by(place_id: data['place_id'])
    return restaurant if restaurant.persisted?

    details = fetch_place_details(data['place_id'])
    binding.pry

    if details['photos'].present?
      photo = details['photos'].first
      photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo['photo_reference']}&key=#{ENV.fetch('GOOGLE_API_KEY', nil)}"
      html_attributions = photo['html_attributions'].first
    end

    restaurant.attributes = {
        place_id: details['place_id'],
        name: details['name'],
        latitude: details['geometry']['location']['lat'],
        longitude: details['geometry']['location']['lng'],
        address: details['formatted_address'] || details['vicinity'],
        rating: details['rating'],
        phone_number: details['formatted_phone_number'],
        categories: details['types'],
        price_level: details['price_level'],
        image_url: photo_url,
        html_attributions: html_attributions,
        url: details['url'],
        opening_hours: details['opening_hours'] ? details['opening_hours']["weekday_text"].join(", ") : "N/A",
        total_ratings: details['user_ratings_total'] || 0
        editorial_summary: details['editorial_summary']
        serves_beer: details['serves_beer']
        serves_wine: details['serves_wine']
      }
    restaurant.save
    restaurant
  end
  
  def self.fetch_place_details(place_id)
    base_url = "https://maps.googleapis.com/maps/api/place/details/json"
    parameters = {
      place_id: place_id,
      fields: 'place_id,name,geometry,formatted_phone_number,vicinity,rating,types,price_level,photos,url,opening_hours,user_ratings_total,editorial_summary,serves_beer,serves_wine',
      key: ENV.fetch('GOOGLE_API_KEY', nil),
      language: 'ja'
    }
    response = Net::HTTP.get(URI("#{base_url}?#{parameters.to_query}"))
    JSON.parse(response)['result']
  end

  def bookmark_count
    bookmarks.count
  end
end
