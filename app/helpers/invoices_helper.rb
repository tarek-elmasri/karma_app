module InvoicesHelper

  def invoice_value_matches_products_value?(invoice)
    order_products = invoice.invoice_products
    products_value = 0
    order_products.each do |order_product|
      products_value += (order_product.product.price * order_product.quantity)
    end

    invoice.value == products_value
  end

  
  def calculate_total_value(invoice_products)
    total = 0
    invoice_products.each do |invoice_product|
      total += (invoice_product.quantity * invoice_product.product.price)
    end
    return total
  end
end
