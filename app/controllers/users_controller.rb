class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # 有効でないユーザーは表示する意味が無いためwhereメソッドを追加
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # ユーザーモデルオブジェクトからメールを送信
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    # ユーザーindexに移動
    redirect_to users_url
  end

  def following
    # タイトルを設定
    @title = "Following"
    # ユーザーを検索
    @user  = User.find(params[:id])
    # @user.followingからデータを取り出し、ページネーションを行う
    @users = @user.following.paginate(page: params[:page])
    # ページを出力
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private
    ## StrongParameters

    # paramsハッシュでは:user属性を必須とし、
    # 名前、メールアドレス、パスワード、パスワードの確認の属性をそれぞれ許可
    # admin属性を許可しないことで、
    # 任意のユーザーが自分自身にアプリケーションの管理者権限を与えることを防止
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    ## BeforeAction

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end