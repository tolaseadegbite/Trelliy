Rails.application.routes.draw do
  get "/home", to: "pages#home", as: :home
  get "/pricing", to: "pages#pricing", as: :pricing
  get "/documentation", to: "pages#documentation", as: :documentation
  get "/help", to: "pages#help", as: :help
  get "/privacy", to: "pages#privacy", as: :privacy
  get "/contact", to: "pages#contact", as: :contact
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
