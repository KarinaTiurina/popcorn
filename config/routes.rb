Rails.application.routes.draw do
  devise_for :users

  root 'films#index'

  resources :films, only: [:show, :index]

  resources :users, only: [:show, :edit, :update]
end
