class Restaurant < ApplicationRecord
    has_many :bookmarks
    has_many :users_who_bookmarked, through: :bookmarks, source: :user
    
    validates :place_id, presence: true
    validates :name, presence: true
    validates :latitude, presence: true
    validates :longitude, presence: true
end
