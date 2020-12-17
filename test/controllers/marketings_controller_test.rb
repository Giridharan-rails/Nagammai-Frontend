require 'test_helper'

class MarketingsControllerTest < ActionDispatch::IntegrationTest
  test "should get _form" do
    get marketings__form_url
    assert_response :success
  end

  test "should get index" do
    get marketings_index_url
    assert_response :success
  end

  test "should get new" do
    get marketings_new_url
    assert_response :success
  end

  test "should get edit" do
    get marketings_edit_url
    assert_response :success
  end

  test "should get show" do
    get marketings_show_url
    assert_response :success
  end

end
