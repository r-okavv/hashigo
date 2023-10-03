class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_restaurants, through: :bookmarks, source: :restaurant
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications
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
