require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  #Further tests will be done in the integration section
end
