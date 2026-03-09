Rails.application.routes.draw do
  root 'home#index'
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :categories, only: [:index, :new, :create]
  
  namespace :api do
    resources :posts, only: [:index, :show]
  end
end
