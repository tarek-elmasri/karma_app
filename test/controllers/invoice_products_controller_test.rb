require 'test_helper'

class InvoiceProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get invoice_products_index_url
    assert_response :success
  end

  test "should get new" do
    get invoice_products_new_url
    assert_response :success
  end

  test "should get edit" do
    get invoice_products_edit_url
    assert_response :success
  end

end
