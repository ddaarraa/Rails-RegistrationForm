class User < ApplicationRecord
  validates :email , presence: true
  validates :firstname , presence: true
  validates :lastname , presence: true
  validates :birthday , presence: true
  validates :phonenumber , presence: true
  validates :gender , presence: true
end
