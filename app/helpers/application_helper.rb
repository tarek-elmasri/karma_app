module ApplicationHelper

  VAT_PERCENTAGE = ENV['VAT_PERCENTAGE_VALUE'].to_f

  def vat_value(value)
    (value * VAT_PERCENTAGE ).round(2)
  end

  def add_vat_value(amount)
    (amount + vat_value(amount)).round(2)
  end

  def detach_vat(value)
    (value / ( 1 + VAT_PERCENTAGE)).round(2)
  end

  def extract_vat(value)
    vat_value(detach_vat(value))
  end
end
