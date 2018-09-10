class User < ApplicationRecord
  # Userモデルの中では右式のselfを省略できる
  # before_save { self.email = email.downcase }
  # before_save { self.email = self.email.downcase }
  # 破壊的downcaseに変更
  before_save { email.downcase! }

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
  validates :password, presence: true, length: { minimum: 6 }
end