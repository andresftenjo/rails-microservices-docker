Rails.application.routes.draw do
  get "/health", to: "health#index"
  scope :auditoria do
    post "/" => "auditoria#create"
    get "/:entity_id" => "auditoria#show_by_entity"
  end
end
