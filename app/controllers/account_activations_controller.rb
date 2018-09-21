class AccountActivationsController < ApplicationController

  # アカウントを有効化するeditアクション
  def edit
    user = User.find_by(email: params[:email])
    # 既に有効になっているユーザーを誤って再度有効化しないため
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # ユーザーを認証してからactivated_atタイムスタンプを更新
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
