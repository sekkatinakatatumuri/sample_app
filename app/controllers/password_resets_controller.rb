class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    # メールアドレスをキーとしてユーザーをデータベースから取得
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    # ユーザーが存在すれば
    if @user
      # パスワード再設定の属性を設定
      @user.create_reset_digest
      # パスワード再設定のメールを送信
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

    private
    
    # params[:email]のメールアドレスに対応するユーザーを取得
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # ユーザーが存在する&有効化されている&認証済みであることを確認
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
end
