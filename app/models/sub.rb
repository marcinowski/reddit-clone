class Sub < ApplicationRecord
  has_many :posts
  validates_uniqueness_of :slug
end
