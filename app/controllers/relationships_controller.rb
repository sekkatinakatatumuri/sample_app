class RelationshipsController < ApplicationController
  # リレーションシップのアクセス制御
  before_action :logged_in_user

  def create
    # followed_idに対応するユーザーを取得
    @user = User.find(params[:followed_id])
    # 取得したユーザーに対してfollowメソッドを実行
    current_user.follow(@user)
    # 元のプロフィールにリダイレクト
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end