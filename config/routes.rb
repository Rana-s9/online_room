Rails.application.routes.draw do
  get "users/show"
  get "rooms/index"
  get "exchange_diaries/index"

  devise_for :users, only: :omniauth_callbacks, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  scope "(:locale)", locale: /en|ja/ do
    devise_for :users, skip: :omniauth_callbacks, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
    }

    resource :user, only: %i[show]
    get "top/index"
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    resources :rooms, only: %i[index show create] do
      resources :exchange_diaries, only: %i[index create update destroy] do
        resource :read, only: %i[create destroy]
      end
      resources :whiteboards, only: %i[create update]
      resources :state_calendars, only: %i[new create index show update edit destroy]
      resources :invitation_tokens, only: %i[create index update]
      resources :greetings, only: %i[new create index edit update destroy]
      resources :spots, only: %i[index new create show edit update destroy]
      resources :calendars, only: %i[index new create show edit update destroy]
    end

    resources :areas, only: %i[create update index]
    resources :weather_records, only: %i[create update]
    resources :posts, only: %i[new create index edit show update destroy] do
      resources :answers, only: %i[create edit destroy], shallow: true
    end
    resources :roommate_lists, only: %i[] do
      collection do
        get "join"  # /roommate_lists/join?token=xxx
      end
    end

    # Defines the root path route ("/")
    root "top#index"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "terms", to: "pages#terms", as: :terms
  get "privacy", to: "pages#privacy", as: :privacy
  get "contact", to: "pages#contact", as: :contact

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
