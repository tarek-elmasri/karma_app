class MainController < ApplicationController
  before_action :authenticate_user

  def index 
    @totals= Client.all.totals
    @clients_last_order_since_one_month_count = Client.where_last_order_since(1.month.ago).count
    @invoices_not_full_paid_since_one_month_count = Invoice.not_full_paid_since(1.month.ago).count
    @last_quarter_average_sales = Invoice.last_quarter_average_sales
    @sales_for_current_month = Invoice.for_month(Date.today.month).total_value
    
  end
  


end
