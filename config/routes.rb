Rails.application.routes.draw do
  get "rooms/index"
  get "exchange_diaries/index"
  devise_for :users, controllers: {
  sessions: "users/sessions",
  registrations: "users/registrations"
  }
  get "top/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :rooms, only: %i[index show create] do
    resources :exchange_diaries, only: %i[index create update destroy]
    resources :whiteboards, only: %i[create update]
    resources :state_calendars, only: %i[new create index update edit destroy]
    resources :invitation_tokens, only: %i[create index update]
    resources :greetings, only: %i[new create index edit update destroy]
    resources :spots, only: %i[index new create show edit update destroy]
  end

  resources :areas, only: %i[create update index]
  resources :weather_records, only: %i[create update]
  resources :posts, only: %i[new create index edit show update destroy]
  resources :roommate_lists, only: %i[] do
    collection do
      get "join"  # /roommate_lists/join?token=xxx
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "top#index"
end
