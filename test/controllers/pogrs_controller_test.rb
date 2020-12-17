require 'test_helper'

class PogrsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pogrs_index_url
    assert_response :success
  end

  test "should get pogr_compare" do
    get pogrs_pogr_compare_url
    assert_response :success
  end

end
