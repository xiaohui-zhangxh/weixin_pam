WeixinPam::Engine.routes.draw do
  resources :public_accounts do
    resources :diymenus, except: :show do
      collection do
        post :sort
        post :upload
      end
    end
    resources :user_accounts
  end
end
