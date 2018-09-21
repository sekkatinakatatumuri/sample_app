module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    # 記憶トークンを生成してトークンのダイジェストをデータベースに保存
    user.remember
    # cookiesメソッドでユーザーIDと記憶トークンの永続cookiesを作成
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      # テストがパスすれば、この部分がテストされていないことがわかる
      # raise
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    # リクエストされたURLが存在する場合はそこにリダイレクト
    # ない場合は何らかのデフォルトのURLにリダイレクト
    redirect_to(session[:forwarding_url] || default)
    # 次回ログイン時に保護されたページに転送されないように、転送用のURLを削除
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを覚えておく
  def store_location
    # request.original_urlでリクエスト先を取得
    # リクエストが送られたURLをsession変数の:forwarding_urlキーに格納。
    # ただし、GETリクエストが送られたときだけ格納
    session[:forwarding_url] = request.original_url if request.get?
  end
end