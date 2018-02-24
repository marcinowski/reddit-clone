require_dependency 'app/lib/searchable_model'

class User < ApplicationRecord
  include SearchableModel, SearchHelper

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USERNAME_REGEX = /\A[a-zA-Z]+_*\z/

  before_save {self.email = email.downcase}
  validates :email,
    presence: true,
    format: {with: VALID_EMAIL_REGEX},
    length: {maximum: 255},
    uniqueness: {case_sensitive: false}

  validates :password,
    presence: true,
    length: {minimum: 6},
    confirmation: true

  validates :username,
    presence: true,
    format: {with: VALID_USERNAME_REGEX, message: "should contain only letters and/or hyphens."},
    length: {minimum: 3, maximum: 255},
    uniqueness: {case_sensitive: true}

  has_secure_password
  has_many :posts
  has_many :comments

  after_create :save_model_for_search

  after_update :update_model_for_search

  before_destroy :destroy_model_from_search

  private
    def save_model_for_search
      save_for_search(self.username, self.class.table_name, self.id)
    end

  private
    def update_model_for_search
      update_for_search(self.username, self.class.table_name, self.id)
    end

end
