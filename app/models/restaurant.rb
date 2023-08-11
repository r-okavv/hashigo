class Restaurant < ApplicationRecord
    validates :place_id, presence: true
    validates :name, presence: true
    validates :latitude, presence: true
    validates :longitude, presence: true
end
