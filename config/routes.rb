Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users

  root "events#index"

  get "/event/add", to: "events#new", as: :new_event
  post "/event/add", to: "events#create", as: :create_event

  get "/event/:event_id", to: "events#show", as: :event
  post "/event/:event_id/main", to: "events#main", as: :main_card
  post "/event/:event_id/prelims", to: "events#prelims", as: :prelims_card
  post "/event/:event_id/early", to: "events#early", as: :early_prelims_card

  get "/event/:event_id/update", to: "events#edit", as: :edit_event
  patch "/event/:event_id/update", to: "events#update", as: :update_event

  delete "/event/:event_id/delete", to: "events#destroy", as: :delete_event

  post "event/:event_id/fights/fighter/:corner/search/:name",
       to: "fighters#search"
  get "/event/:event_id/fights/add", to: "fights#new", as: :new_fight
  post "/event/:event_id/fights/add", to: "fights#create", as: :create_fight

  post "/event/:event_id/fight/:fight_id/up", to: "fights#up", as: :fight_up
  post "/event/:event_id/fight/:fight_id/down",
       to: "fights#down",
       as: :fight_down

  get "/event/:event_id/fight/:fight_id/update",
      to: "fights#edit",
      as: :edit_fight
  patch "/event/:event_id/fight/:fight_id/update",
        to: "fights#update",
        as: :update_fight

  delete "/fight/:fight_id/delete", to: "fights#destroy", as: :delete_fight

  post "event/:event_id/fights/:fight_id/fighter/:fighter_id",
       to: "predictions#submit_method",
       as: :submit_method_prediction

  post "event/:event_id/fights/:fight_id",
       to: "predictions#submit_distance",
       as: :submit_distance_prediction
end
