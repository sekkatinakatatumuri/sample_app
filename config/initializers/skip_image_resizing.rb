# テスト時は画像のリサイズをさせない
if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end