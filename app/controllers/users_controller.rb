class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # 上記と等価
      # redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  private

    # paramsハッシュでは:user属性を必須とし、
    # 名前、メールアドレス、パスワード、パスワードの確認の属性をそれぞれ許可
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end