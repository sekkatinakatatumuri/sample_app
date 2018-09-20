class ApplicationMailer < ActionMailer::Base
  # fromアドレスのデフォルト値を更新
  default from: "noreply@example.com"
  layout 'mailer'
end
