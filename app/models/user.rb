class User < ApplicationRecord
  validates :email , presence: true
  validates :firstname , presence: { message: "Firstname can't be blank" }
  validates :lastname , presence: true

  validates :phonenumber , presence: true , numericality: { only_integer: true }, length: { minimum: 10, maximum: 15 }
  validates :gender , presence: true
  validates :birthday, presence: true


  validate  :valid_birthday

  private
  def valid_birthday
    if birthday.present? && birthday > Date.today
      errors.add(:birthday, "can't be in the future")
    end
  end
end
