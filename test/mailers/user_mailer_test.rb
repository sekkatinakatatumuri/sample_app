require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  # 送信メールのテスト
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  test "account_activation" do
    # fixtureユーザーに有効化トークンを追加
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    # 正規表現で文字列を確認
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    # エスケープ済みメールアドレスがメール本文に含まれているか確認
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
  
  # パスワード再設定用メイラーメソッドのテスト
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
