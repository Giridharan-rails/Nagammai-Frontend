require 'test_helper'

class PaymentTermsControllerTest < ActionDispatch::IntegrationTest
  test "should get _form" do
    get payment_terms__form_url
    assert_response :success
  end

  test "should get index" do
    get payment_terms_index_url
    assert_response :success
  end

  test "should get new" do
    get payment_terms_new_url
    assert_response :success
  end

  test "should get edit" do
    get payment_terms_edit_url
    assert_response :success
  end

  test "should get show" do
    get payment_terms_show_url
    assert_response :success
  end

end
