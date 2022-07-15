Rails.application.routes.draw do
  root 'events#index'
  get "/event/add", to: "events#new", as: :new_event
  post "/event/add", to: "events#create"
  
  get "/event/:event_id", to: "events#show", as: :event
  get "/event/:event_id", to: "events#update"

  get "/event/:event_id/fights/add", to: "fights#new", as: :new_fight
  post "/event/:event_id/fights/add", to: "fights#create", as: :create_fight
  post "/event/:event_id/fights/search", to: "fights#search", as: :search_fight


  get "/event/:event_id/fight/:fight_id/update", to: "fights#edit", as: :edit_fight
  patch "/event/:event_id/fight/:fight_id/update", to: "fights#update", as: :update_fight

  delete "fight/:fight_id/delete/", to: "fights#destroy", as: :delete_fight

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
