class Micropost < ApplicationRecord
  belongs_to :user
  # データベースから要素を取得したときの、デフォルトの順序を指定するメソッド
  default_scope -> { order(created_at: :desc) }
  # CarrierWaveに画像と関連付けたモデルを伝える
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
