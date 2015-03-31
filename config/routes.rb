Rails.application.routes.draw do

  resources :posts

  devise_for :admins
  devise_for :users,:controllers => {omniauth_callbacks: "omniauth_callbacks", :registrations => "registrations", :sessions => "sessions", :confirmations => "confirmations" }
  root :to => "homes#index"
  resources :homes, :only => :index

  namespace :user do 
    resources :homes
  end

  namespace :admin do 
    resources :homes
  end

  resources :articles
  
end