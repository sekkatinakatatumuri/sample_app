Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'

  # ルートはapplication_controllerのhelloアクション
  root 'application#hello'
end
