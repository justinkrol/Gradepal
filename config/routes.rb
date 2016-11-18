Rails.application.routes.draw do
  root 'home#index'

  resources :courses, only: [:index, :show, :create, :update, :destroy] do
    resources :components, only: [:index, :show, :create, :update, :destroy] do
      resources :grades, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
