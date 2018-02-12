class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save {self.email = email.downcase}

  validates :email,
    presence: true,
    format: {with: VALID_EMAIL_REGEX},
    length: {maximum: 255},
    uniqueness: {case_sensitive: false}

  validates :password,
    presence: true,
    length: {minimum: 6}

  has_secure_password
end
