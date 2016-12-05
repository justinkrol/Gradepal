Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :user
  resources :courses
  resources :components
  resources :grades
end
