require 'test_helper'

class ClaimIssuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @claim_issue = claim_issues(:one)
  end

  test "should get index" do
    get claim_issues_url
    assert_response :success
  end

  test "should get new" do
    get new_claim_issue_url
    assert_response :success
  end

  test "should create claim_issue" do
    assert_difference('ClaimIssue.count') do
      post claim_issues_url, params: { claim_issue: {  } }
    end

    assert_redirected_to claim_issue_url(ClaimIssue.last)
  end

  test "should show claim_issue" do
    get claim_issue_url(@claim_issue)
    assert_response :success
  end

  test "should get edit" do
    get edit_claim_issue_url(@claim_issue)
    assert_response :success
  end

  test "should update claim_issue" do
    patch claim_issue_url(@claim_issue), params: { claim_issue: {  } }
    assert_redirected_to claim_issue_url(@claim_issue)
  end

  test "should destroy claim_issue" do
    assert_difference('ClaimIssue.count', -1) do
      delete claim_issue_url(@claim_issue)
    end

    assert_redirected_to claim_issues_url
  end
end
