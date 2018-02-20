class User < ApplicationRecord
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
end
