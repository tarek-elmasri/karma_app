module InvoicesTestable extend ActiveSupport::Concern

  module ClassMethods 
    def not_full_paid_since(date = 1.month.ago)
      where(
        aq(:value , :gt , arel_table[:paid])
        .and(
          aq(:date, :lt , date)
        )
      )
    end

    def last_quarter_average_sales
      last_month = Date.today.ago(1.month).beginning_of_month
      average = Invoice.where(Invoice.arel_table[:date].between(last_month.ago(2.month)..last_month.end_of_month))
        .sum(:value)

      result = (average / 3).to_i
    end

    def for_month(month=Date.today.month)
      date = Date.new(Date.today.year,month,1)
      where(arel_table[:date].between(date..date.end_of_month))

    end

  end

end
