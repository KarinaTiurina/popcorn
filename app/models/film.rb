class Film < ApplicationRecord
  include PgSearch
  pg_search_scope :search, against: [:title, :director, :year],
                  using: {tsearch: {dictionary: "russian"}}

  validates :title, presence: true
  validates :director, presence: true
  validates :year, presence: true

  mount_uploader :poster, PosterUploader
end
