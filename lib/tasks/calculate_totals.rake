namespace :calculate_totals do
    desc "calculating client,invoices and payments totals"
    task :commit => :environment do
      clients = Client.order(:id)
      clients.each do |client|
        client.invoices.each do |invoice|
          invoice.calculate_client_total_sales
          invoice.update({paid: invoice.payments.total})
        end
      end
    end
end
