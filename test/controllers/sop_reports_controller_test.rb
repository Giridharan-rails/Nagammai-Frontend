require 'test_helper'

class SopReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sop_reports_index_url
    assert_response :success
  end

end
