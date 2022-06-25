Rails.application.routes.draw do
  root 'events#index'
  get "create_event", to: "events#new", as: :create
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
