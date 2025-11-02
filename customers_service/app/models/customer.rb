class Customer < ApplicationRecord
  validates :name, :tax_id, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end