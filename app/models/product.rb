class Product < ApplicationRecord
  has_many :invoice_products
  has_many :invoices , through: :invoice_products

  validates :name, presence:true , length: {minimum: 3, maximum: 20}
  validates :description, presence:true , length: {minimum: 3}
  validates :price, presence:true , numericality: true
  validates :active , inclusion: {in: [true,false]}
end
