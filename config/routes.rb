Rails.application.routes.draw do
  root 'events#index'
  get "/add_event", to: "events#new", as: :new_event
  post "/add_event", to: "events#create"
  
  get "/event/:event_id", to: "events#show", as: :event
  get "/event/:event_id", to: "events#update"

  get "/event/:event_id/add_fight", to: "fights#new", as: :new_fight
  post "/event/:event_id/add_fight", to: "fights#create", as: :create_fight
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
