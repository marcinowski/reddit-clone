require_dependency 'app/lib/searchable_model'

class Post < ApplicationRecord
  include SearchHelper, SearchableModel

  has_many :comments, dependent: :destroy
  has_many :rating_posts, dependent: :destroy
  has_one :post_image, dependent: :destroy
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

  after_create do
    :save_model_for_search
    self.create_post_image(url: self.url)
  end

  after_update :update_model_for_search

  before_destroy :destroy_model_from_search

  private
    def save_model_for_search
      save_for_search(self.title, self.class.table_name, self.id)
      unless self.description.nil?
        save_for_search(self.description, self.class.table_name, self.id)
      end
    end

  private
    def update_model_for_search
      update_for_search(self.title, self.class.table_name, self.id)
      unless self.description.nil?
        update_for_search(self.description, self.class.table_name, self.id)
      end
    end

  def url_or_description?
    if url.blank? && description.blank?
      errors.add(:description, "can't be blank if you don't specify url.")
    end
  end
end
