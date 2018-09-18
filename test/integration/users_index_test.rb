require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    # ログインする
    log_in_as(@user)
    # usersのindexページにアクセス
    get users_path
    # テンプレートの確認
    assert_template 'users/index'
    # ページネーションのリンクがあることを確認
    assert_select 'div.pagination', count:2
    # 最初のページにユーザーがいることを確認
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end
