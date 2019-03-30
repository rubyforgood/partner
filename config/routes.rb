Rails.application.routes.draw do
  resources :children
  resources :families
  devise_for :partners, controllers: { sessions: "partners/sessions" }
  devise_scope :partner do
    get "/partners/sign_out" => "devise/sessions#destroy"
  end

  resources :partners do
    get :approve
  end

  resources :partner_requests, only: [:new, :create, :show, :index]

  get "/api", action: :show, controller: "api"
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :partners
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "pages/:name", to: "static#page"
  root "static#index"
end
