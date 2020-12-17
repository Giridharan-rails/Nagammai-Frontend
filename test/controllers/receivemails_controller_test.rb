require 'test_helper'

class ReceivemailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get receivemails_index_url
    assert_response :success
  end

  test "should get _form" do
    get receivemails__form_url
    assert_response :success
  end

  test "should get show" do
    get receivemails_show_url
    assert_response :success
  end

  test "should get edit" do
    get receivemails_edit_url
    assert_response :success
  end

  test "should get new" do
    get receivemails_new_url
    assert_response :success
  end

end
