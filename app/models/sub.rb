class Sub < ApplicationRecord
  include SearchHelper, SearchableModel
  has_many :posts
  has_one :sub_info
  has_many :sub_moderators
  has_many :sub_subscriptions
  has_many :sub_bans

  validates_uniqueness_of :slug
  validates :slug,
    presence: true,
    length: {maximum: 255, minimum: 3},
    uniqueness: {case_sensitive: false},
    exclusion: {in: %w(new), message: "%{value} is reserved."},
    format: {with: /\A[a-zA-Z_]+\z/, message: "%{value} contains forbidden characters. Please use only letters and '_'"}

  after_create :save_model_for_search

  after_update :update_model_for_search

  before_destroy :destroy_model_from_search

  private
    def save_model_for_search
      save_for_search(self.slug, self.class.table_name, self.id)
    end

  private
    def update_model_for_search
      update_for_search(self.slug, self.class.table_name, self.id)
      unless self.description.nil?
        update_for_search(self.description, self.class.table_name, self.id)
      end
    end
end
