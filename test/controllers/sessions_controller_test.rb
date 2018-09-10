require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    # Sessionsコントローラのテストで名前付きルートを使う
    # get sessions_new_url
    
    get login_path
    assert_response :success
  end

end
