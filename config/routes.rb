Rails.application.routes.draw do
  # Auth
  resource :session
  resources :passwords, param: :token
  resource :registration, only: %i[new create]

  # App (authenticated)
  get "dashboard", to: "dashboard#show"
  resources :waitlists do
    resources :subscribers, only: %i[index show destroy] do
      collection do
        get :export
      end
    end
  end

  # Billing
  get "pricing", to: "pricing#index"
  resource :subscription, only: %i[create]
  namespace :webhooks do
    post "stripe", to: "stripe#create"
  end
  get "billing", to: "billing#show"

  # Health check (before catch-all)
  get "up" => "rails/health#show", as: :rails_health_check
  get "health", to: "health#show"

  root "marketing#index"

  # Catch-all for public waitlist slugs - must be very last
  get ":slug", to: "public_pages#show", as: :public_page, constraints: { slug: /[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/ }
  post ":slug/subscribe", to: "public_pages#subscribe", as: :public_page_subscribe, constraints: { slug: /[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/ }
end
