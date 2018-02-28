class Sub < ApplicationRecord
  has_many :posts
  has_one :sub_info
  validates_uniqueness_of :slug
  validates :slug,
    presence: true,
    length: {maximum: 255, minimum: 3},
    uniqueness: {case_sensitive: false},
    exclusion: {in: %w(new), message: "%{value} is reserved."},
    format: {with: /\A[a-zA-Z_]+\z/, message: "%{value} contains forbidden characters. Please use only letters and '_'"}
end
