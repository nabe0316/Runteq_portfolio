Rails.application.routes.draw do
  devise_for :users

  root 'static_pages#top'
  get 'home', to: 'home#index', as: :home
  resources :messages, only: [:new, :create, :show, :edit, :update]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
