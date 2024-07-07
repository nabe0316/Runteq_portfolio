Rails.application.routes.draw do
  devise_for :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  root 'static_pages#top'
  get 'home', to: 'home#index', as: :home

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
