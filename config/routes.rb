Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#top'
  get 'home', to: 'home#index', as: :home

  resources :messages do
    member do
      post 'like'
      delete 'unlike'
    end
  end

  resources :profiles, only: [:show, :edit, :update]
  get 'users/:id/profile', to: 'profiles#show', as: :user_profile

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
