require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    # usersはfixtureのファイル名users.ymlを表し、
    # :michaelというシンボルはユーザーを参照するためのキーを表す。
    @user = users(:michael)
  end

  # ログイン失敗時テスト
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # ログイン成功時テスト
  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    # ログインの確認
    assert is_logged_in?
    # リダイレクト先が正しいかどうかを確認
    assert_redirected_to @user
    # ログイン用リンクが表示されなくなったことも確認
    follow_redirect!
    assert_template 'users/show'
    # count: 0というオプションをassert_selectに追加すると、
    # 渡したパターンに一致するリンクが０かどうかを確認
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # ログアウト処理
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
