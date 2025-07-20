class Owner < ApplicationRecord
  has_many :pets, dependent: :destroy

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
end
