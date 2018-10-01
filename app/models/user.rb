class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                foreign_key: "follower_id",
                                dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed

  attr_accessor :remember_token, :activation_token, :reset_token

  # Userモデルの中では右式のselfを省略できる
  # before_save { self.email = email.downcase }
  # before_save { self.email = self.email.downcase }
  # 破壊的downcaseに変更
  # before_save { email.downcase! }
  # 上記をメソッド参照に切り替える
  before_save   :downcase_email

  # オブジェクトが作成されたときだけコールバックを呼び出す
  before_create :create_activation_digest

  # 名前
  # メソッドの最後の引数としてハッシュを渡す場合、波カッコを付けなくてもよい
  # validates(:name, presence: true)
  validates :name, presence: true,  length: { maximum: 50 }

  # メールアドレス
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # パスワード
  has_secure_password
  validates :password, presence: true,
                       length: { minimum: 6 },
                       allow_nil: true

  # クラスメソッド
  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    # 記憶ダイジェストがnilの場合にfalseを返す
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    # update_attribute(:reset_digest,  User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    # 下記にリファクタリング
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    # パスワード再設定メールの送信時刻が、現在時刻より2時間以上前 (早い) の場合
    reset_sent_at < 2.hours.ago
  end

  # 現在ログインしているユーザーのマイクロポストをすべて取得
  def feed
    Micropost.where("user_id = ?", id)
  end

    private

    # メールアドレスをすべて小文字にする
    def downcase_email
      # self.email = email.downcase
      self.email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
