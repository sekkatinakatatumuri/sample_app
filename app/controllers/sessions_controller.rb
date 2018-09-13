class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # ユーザーがデータベースにあり、かつ、認証に成功した場合
    if user && user.authenticate(params[:session][:password])
      log_in user
      # ログインしたユーザーを記憶するヘルパーメソッド
      remember user
      redirect_to user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
