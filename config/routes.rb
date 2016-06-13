Rails.application.routes.draw do
  root 'home#index'
  resources :courses, only: [:index, :show, :create, :update, :destroy]
end
