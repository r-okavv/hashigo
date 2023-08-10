class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :bookmarks
  has_many :bookmarked_restaurants, through: :bookmarks, source: :restaurant
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

end
