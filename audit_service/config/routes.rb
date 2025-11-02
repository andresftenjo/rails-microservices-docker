Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get "/health", to: "health#index"
  scope :auditoria do
    post "/" => "auditoria#create"
    get "/:entity_id" => "auditoria#show_by_entity"
  end
end
