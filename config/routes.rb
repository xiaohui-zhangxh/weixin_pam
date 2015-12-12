WeixinPam::Engine.routes.draw do
  resources :public_accounts do
    resources :user_accounts
  end
end
