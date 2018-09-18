require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  
  # 未ログイン時のレイアウトをテスト
  test "layout links" do
    get root_path
    # Homeページが正しいビューを描画しているかどうか確認
    assert_template 'static_pages/home'
    # 特定のリンクが存在するかどうかを、aタグとhref属性をオプションで指定して確認
    # "?"をroot_pathに置換、rootはロゴも含め2つあるので数を確認
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path

    get contact_path
    assert_select "title", full_title("Contact")

    get signup_path
    assert_select "title", full_title("Sign up")
  end
  
  # ログイン済み時のレイアウトをテスト
  test "layout links when logged in" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)    
    assert_select "a[href=?]", logout_path
  end
  
  
end