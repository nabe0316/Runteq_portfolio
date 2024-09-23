require "test_helper"

class TreesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get trees_edit_url
    assert_response :success
  end

  test "should get update" do
    get trees_update_url
    assert_response :success
  end

  test "should get preview" do
    get trees_preview_url
    assert_response :success
  end
end
