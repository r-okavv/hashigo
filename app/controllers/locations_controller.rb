class LocationsController < ApplicationController
    def get_location
    latitude = params[:latitude]
    longitude = params[:longitude]
    address = ""

    if latitude.present? && longitude.present?
      location = Geocoder.search([latitude, longitude], language: :ja).first
      address = location.address if location.present?
    end

    render json: {address: address}
  end
end
