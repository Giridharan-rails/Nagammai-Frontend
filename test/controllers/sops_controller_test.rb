require 'test_helper'

class SopsControllerTest < ActionDispatch::IntegrationTest
  test "should get _form" do
    get sops__form_url
    assert_response :success
  end

  test "should get index" do
    get sops_index_url
    assert_response :success
  end

  test "should get new" do
    get sops_new_url
    assert_response :success
  end

  test "should get edit" do
    get sops_edit_url
    assert_response :success
  end

  test "should get show" do
    get sops_show_url
    assert_response :success
  end

end
