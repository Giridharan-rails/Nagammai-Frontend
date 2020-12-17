require 'test_helper'

class CfasControllerTest < ActionDispatch::IntegrationTest
  test "should get _form" do
    get cfas__form_url
    assert_response :success
  end

  test "should get index" do
    get cfas_index_url
    assert_response :success
  end

  test "should get new" do
    get cfas_new_url
    assert_response :success
  end

  test "should get edit" do
    get cfas_edit_url
    assert_response :success
  end

  test "should get show" do
    get cfas_show_url
    assert_response :success
  end

end
