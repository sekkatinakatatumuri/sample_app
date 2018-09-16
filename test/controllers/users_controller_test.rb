require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    # 別のユーザを作成
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  # editアクションの保護に対するテスト
  test "should redirect edit when not logged in" do
    # getでeditアクションを実行
    get edit_user_path(@user)
    # flashにメッセージが代入されたか確認
    assert_not flash.empty?
    # ログイン画面にリダイレクトされたか確認
    assert_redirected_to login_url
  end

  # updateアクションの保護に対するテスト
  test "should redirect update when not logged in" do
    # patchでeditアクションを実行
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # 間違ったユーザーでeditアクションを実行したときのテスト
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # 間違ったユーザーでupdateアクションを実行したときのテスト
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
