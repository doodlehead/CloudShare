require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid user signup information" do
    get signup_path #navigate to the signup page
    assert_no_difference 'User.count' do #check if the User.count changes
      post users_path, params: { user: { name: "frank", email: "f@email.com", password: "password1", password_confirmation: "password"}} #post to the user_path
      post users_path, params: { user: { name: "frank", email: "f@email.com", password: "pass", password_confirmation: "pass"}}
    end
  end
  
  test "valid user signup information" do
    get signup_path #navigate to the signup page
    assert_difference 'User.count', 2 do #check if the User.count changes
      post users_path, params: { user: { name: "Will", email: "will@email.com", password: "password5", password_confirmation: "password5"}} #post to the user_path
      post users_path, params: { user: { name: "frank", email: "f@email.com", password: "password", password_confirmation: "password"}}
    end
  end
  
end
