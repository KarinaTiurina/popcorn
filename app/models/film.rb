class Film < ApplicationRecord
  include PgSearch
  pg_search_scope :search, against: [:title, :director, :year],
                  using: {tsearch: {dictionary: "russian"}}

  has_many :comments

  has_many :film_users, dependent: :destroy
  has_many :users, through: :film_users, source: :user

  validates :title, presence: true
  validates :director, presence: true
  validates :year, presence: true
  validates :kinopoisk_id, presence: true
  validates :kinopoisk_id, uniqueness: true


  mount_uploader :poster, PosterUploader
end
