require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  # adminユーザーでユーザー一覧画面を表示した時のテスト
  test "index as admin including pagination and delete links" do
    # 特権ユーザーでログインする
    log_in_as(@admin)
    # usersのindexページにアクセス
    get users_path
    # テンプレートの確認
    assert_template 'users/index'
    # ページネーションのリンクがあることを確認
    assert_select 'div.pagination', count:2
    # 最初のページにユーザーがいることを確認
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      # 特権ユーザー以外のユーザーにdeleteリンクが表示されているか確認
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    # 管理者が削除リンクをクリックしたときに、ユーザーが削除されたことを確認
    # User.countを使ってユーザー数が1減ったかどうかを確認
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  # non-adminユーザーでユーザー一覧画面を表示した時のテスト
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    # deleteリンクが無い事を確認
    assert_select 'a', text: 'delete', count: 0
  end
end
