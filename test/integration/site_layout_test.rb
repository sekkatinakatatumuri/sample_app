require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

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

    get contact_path
    assert_select "title", full_title("Contact")

    get signup_path
    assert_select "title", full_title("Sign up")
  end
end