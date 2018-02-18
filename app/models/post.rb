class Post < ApplicationRecord
  has_many :comments
  belongs_to :user
  belongs_to :sub
  validates :sub,
    presence: true
  validates :title,
    presence: true,
    length: {minimum: 3}
  validates :description,
    presence: true
  validates :url,
    format: {with: URI.regexp(['http', 'https'])}
end
