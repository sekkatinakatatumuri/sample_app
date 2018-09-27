require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end
  
  # プロフィール画面に対するテスト
  test "profile display" do
    # プロフィール画面にアクセス
    get user_path(@user)
    assert_template 'users/show'
    # ページタイトル確認
    assert_select 'title', full_title(@user.name)
    # ユーザー名
    assert_select 'h1', text: @user.name
    # Gravatarの確認
    assert_select 'h1>img.gravatar'
    # マイクロポストの投稿数の確認
    assert_match @user.microposts.count.to_s, response.body
    # ページ分割されたマイクロポストの確認
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end