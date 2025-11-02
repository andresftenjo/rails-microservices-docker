Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get "/health", to: "health#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  scope :facturas do
    post "/" => "facturas#create"
    get "/"  => "facturas#index"
    get "/:id" => "facturas#show"
  end

  resources :facturas, only: [:create, :show, :index] if defined?(FacturasController)
end
