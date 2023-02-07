Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "homes#top"
  get "home/about"=>"homes#about"
  get "searches/search" => "searches#search"
  devise_for :users

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, oniy: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :follows, :followers
    end
      resource :relationships, only: [:create, :destroy]
  end
  
  resources :rooms, only: [:create, :show]
  resources :messages, only: [:creat]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
