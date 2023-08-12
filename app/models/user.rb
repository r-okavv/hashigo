class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :bookmarks
  has_many :bookmark_restaurants, through: :bookmarks, source: :restaurant
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  def bookmark(restaurant)
    bookmark_restaurants << restaurant
  end

  def unbookmark(restaurant)
    bookmark_restaurants.destroy(restaurant)
  end

  def bookmark?(restaurant)
    bookmark_restaurants.include?(restaurant)
  end

end
