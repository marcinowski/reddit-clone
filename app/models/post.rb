class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :sub
  validates :sub,
    presence: true
  validates :title,
    presence: true,
    length: {minimum: 3}
  validates :url,
    allow_blank: true,
    format: {with: URI.regexp(['http', 'https'])}
  validate :url_or_description?

  def url_or_description?
    if url.blank? && description.blank?
      errors.add(:description, "can't be blank if you don't specify url.")
    end
  end
end
