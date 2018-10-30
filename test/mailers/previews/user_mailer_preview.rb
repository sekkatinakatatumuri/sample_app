# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    # user変数が開発用データベースの最初のユーザーになるように定義
    user = User.first
    # activation_tokenに代入
    user.activation_token = User.new_token
    # account_activationの引数には有効なUserオブジェクトを渡す必要がある
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
