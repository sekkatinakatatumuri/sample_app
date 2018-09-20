require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  # 送信メールのテスト
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
end
