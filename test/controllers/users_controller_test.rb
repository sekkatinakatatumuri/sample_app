require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    # 別のユーザを作成
    @other_user = users(:archer)
  end

  # indexアクションが正しくリダイレクトするか検証するテスト
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
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

  # admin属性の変更が禁止されていることをテスト
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    # PATCHを直接ユーザーのURL (/users/:id) に送信する
    patch user_path(@other_user), params: {
                                    user: { password:              @other_user.password,
                                            password_confirmation: @other_user.password,
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  # 間違ったユーザーでeditアクションを実行するテスト
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # 間違ったユーザーでupdateアクションを実行するテスト
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # 未ログインユーザーでdestroyアクションを実行するテスト
  test "should redirect destroy when not logged in" do
    # ユーザー数が変化しないことを確認
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    # ログイン画面にリダイレクト
    assert_redirected_to login_url
  end

  # ログイン済みだが管理者でないユーザーでdestroyアクションを実行するのテスト
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    # ホーム画面にリダイレクト
    assert_redirected_to root_url
  end

  # 未ログインユーザーでfollowingアクションを実行するテスト
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end
  
  # 未ログインユーザーでfollowersアクションを実行するテスト
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end