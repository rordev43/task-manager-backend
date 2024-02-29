require "test_helper"

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get tasks" do
    get api_users_tasks_url
    assert_response :success
  end
end
