WeixinPam::Engine.routes.draw do
  resources :public_accounts do
    resources :diymenus
    resources :user_accounts
  end
end
