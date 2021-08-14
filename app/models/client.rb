class Client < ApplicationRecord
  has_many :invoices
  has_many :charged_persons

  scope :total_count, -> {all.count}

  validates :name, presence: {message: 'الاسم مطلوب'}
  validates :area, presence: {message: 'المنطقة مطلوبة'}
  

  def total_invoice_sum
    invoices.sum(:value)
  end

  def total_invoices_count
    invoices.all.count
  end

  def total_paid
    paid = 0
    invoices.each  do |invoice|
      paid += invoice.payments.sum(:amount)
    end
    paid
  end

  def total_remaining
    total_invoice_sum - total_paid
  end
end
