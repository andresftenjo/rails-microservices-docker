class Invoice < ApplicationRecord
  validates :customer_id, :amount, :issued_on, presence: true
  validates :amount, numericality: { greater_than: 0 }
end