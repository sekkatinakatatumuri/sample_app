class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # ユーザーがデータベースにあり、かつ、認証に成功した場合
    if @user && @user.authenticate(params[:session][:password])
      # 有効なユーザーの場合ログインする
      if user.activated?
        log_in @user
        # ログインしたユーザーを記憶するヘルパーメソッド
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      # 有効でない場合はルートURLにリダイレクトしてwarningで警告
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # ログイン中の場合のみログアウトする
    log_out if logged_in?
    redirect_to root_url
  end
end
