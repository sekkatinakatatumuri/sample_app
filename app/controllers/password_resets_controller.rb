class PasswordResetsController < ApplicationController
  def new
  end

  def create
    # メールアドレスをキーとしてユーザーをデータベースから取得
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    # ユーザーが存在すれば
    if @user
      # パスワード再設定用トークンと
      # 送信時のタイムスタンプでデータベースの属性を更新
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
end
