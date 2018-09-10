require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # 失敗時テスト
  test "invalid signup information" do
    # getメソッドを使ってユーザー登録ページにアクセス
    get signup_path
    assert_no_difference 'User.count' do
      # Rails 4.2以前では、paramsを暗黙的に省略してもテストが通りました。
      # Rails 5.0からは非推奨

      # assert_no_differenceメソッドのブロック内でpostを使い、
      # メソッドの引数には’User.count’を与える部分は、
      # assert_no_differenceのブロックを実行する前後で引数の値 (User.count) が
      # 変わらないことをテスト
      post users_path, params: { user: {  name:  "",
                                          email: "user@invalid",
                                          password:              "foo",
                                          password_confirmation: "bar" } }
    end
    # newアクションが再描画されるかのテスト
    # 非推奨では？
    assert_template 'users/new'
    # エラーメッセージのテスト
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
    
  # 成功時テスト
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # POSTリクエストを送信した結果を見て、
    # 指定されたリダイレクト先に移動するメソッド
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
