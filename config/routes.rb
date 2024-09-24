Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#top'
  get 'home', to: 'home#index', as: :home

  resources :messages do
    resource :like, only: [:create, :destroy]
    collection do
      get :autocomplete
    end
  end

  resources :notifications, only: [:index, :destroy] do
    collection do
      post :mark_as_read
    end
  end

  resources :profiles, only: [:show, :edit, :update]
  resource :tree, only: [:edit, :update]

  get 'users/:id/profile', to: 'profiles#show', as: :user_profile
  get '/terms', to: 'pages#terms'
  get '/privacy', to: 'pages#privacy'
  get '/contact', to: 'pages#contact'
  post '/submit_contact', to: 'pages#submit_contact'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
