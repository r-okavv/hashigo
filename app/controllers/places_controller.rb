require 'net/http'
require 'json'

class PlacesController < ApplicationController

    # def search
    #     address = params[:address]
    #     api_key = ENV['GOOGLE_API_KEY']
    #     base_url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
    #     location = Geocoder.coordinates(address)

    #     radius = 100

    #     if @address
    #         redirect_to result_path
    #     end
    # end

    # def result
    # end


  def index
    @places = []
  end

  def search
    address = params[:address]
    if address.present?
      @places = fetch_nearby_places(address)
    else
      @places = []
    end

    render :index
  end

  private

  def fetch_nearby_places(address)
    base_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    radius = 50 # 50m radius for nearby places
    api_key = ENV['GOOGLE_API_KEY']

    url = "#{base_url}?location=#{CGI.escape(address)}&radius=#{radius}&key=#{api_key}"

    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data['status'] == 'OK'
      data['results']
    else
      []
    end
  end
end
