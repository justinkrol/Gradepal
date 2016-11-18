Rails.application.routes.draw do
  root 'home#index'

  resources :courses
  resources :components
  resources :grades
end
