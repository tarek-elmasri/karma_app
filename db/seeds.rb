# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)




      clients = Client.order(:id)
      clients.each do |client|
        client.invoices.each do |invoice|
          invoice.calculate_client_total_sales
          invoice.update({paid: invoice.payments.total})
        end
      end