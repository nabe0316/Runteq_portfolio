Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#top'
  get 'home', to: 'home#index', as: :home

  resources :messages do
    resource :like, only: [:create, :destroy]
  end

  resources :notifications, only: [:index] do
    collection do
      post :mark_as_read
    end
  end

  resources :profiles, only: [:show, :edit, :update]

  get 'users/:id/profile', to: 'profiles#show', as: :user_profile
  get '/terms', to: 'pages#terms'
  get '/privacy', to: 'pages#privacy'
  get '/contact', to: 'pages#contact'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
