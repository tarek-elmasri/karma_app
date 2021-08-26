class Payment < ApplicationRecord
  belongs_to :invoice
  delegate :client , to: :invoice
  # rename to total
  scope :total, -> {sum(:amount)}
  scope :total_cash, -> {where(payment_method: 'cash').sum(:amount)}
  scope :total_transfer, -> {where(payment_method: 'transfer').sum(:amount) }

  after_save :reset_calculation

  validates :amount, presence: {message: 'المبلغ المدفوع مطلوب'} , numericality: {message: "المبلغ يجب ان يكون رقم"}
  validates :payment_method , presence: {message: 'طريقة السداد مطلوبة'} , inclusion: { in: ['cash', 'transfer'] , message: 'طريقة السداد اما نقدا او تحويل بنكي'}
  validates :date , presence: {message: 'تاريخ السداد مطلوب'}

  def reset_calculation
    invoice.update_attribute(:paid, invoice.payments.total)
  end

end
