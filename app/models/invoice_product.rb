class InvoiceProduct < ApplicationRecord
  belongs_to :invoice
  belongs_to :product

  validates :invoice_id,  presence: true , uniqueness: {scope: :product_id}
  validates :product_id , presence:true
  validates :quantity , numericality: {only_integer: true}
end
