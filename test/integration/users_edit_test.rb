require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # ユーザ編集失敗時テスト
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end

  # ユーザ編集成功時テスト
  test "successful edit" do
    # テストユーザでログインする
    log_in_as(@user)
    # ユーザー情報を更新する正しい振る舞い
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    # flashメッセージが空でないか確認
    assert_not flash.empty?
    # プロフィールページにリダイレクトされるか確認
    assert_redirected_to @user
    # DB内のユーザー情報が正しく変更されたか確認
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
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
end