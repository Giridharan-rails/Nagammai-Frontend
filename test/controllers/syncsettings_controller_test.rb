require 'test_helper'

class SyncsettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get _form" do
    get syncsettings__form_url
    assert_response :success
  end

  test "should get index" do
    get syncsettings_index_url
    assert_response :success
  end

  test "should get new" do
    get syncsettings_new_url
    assert_response :success
  end

  test "should get edit" do
    get syncsettings_edit_url
    assert_response :success
  end

  test "should get show" do
    get syncsettings_show_url
    assert_response :success
  end

end
