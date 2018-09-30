if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => ENV['ap-northeast-1'],     # 例: 'ap-northeast-1'
      :aws_access_key_id     => ENV['AKIAIIM24JXVGZZ3SIVA'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['sekkatinakatatumuri']
  end
end