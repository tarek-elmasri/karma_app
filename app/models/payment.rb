class Payment < ApplicationRecord
  belongs_to :invoice

  scope :total_amount, -> {sum(:amount)}

  validates :amount, presence: {message: 'المبلغ المدفوع مطلوب'} , numericality: {message: "المبلغ يجب ان يكون رقم"}
  validates :payment_method , presence: {message: 'طريقة السداد مطلوبة'} , inclusion: { in: ['cash', 'transfer'] , message: 'طريقة السداد اما نقدا او تحويل بنكي'}
  validates :date , presence: {message: 'تاريخ السداد مطلوب'}
end
