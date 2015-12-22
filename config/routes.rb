WeixinPam::Engine.routes.draw do
  resources :public_accounts do
    resources :diymenus, except: :show do
      collection do
        post :sort
        post :upload
        post :download
      end
    end
    resources :user_accounts, only: [:index] do
      collection do
        post :sync
      end
    end
  end
  mount WeixinRailsMiddleware::Engine, at: "/"
end
