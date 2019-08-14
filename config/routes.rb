Rails.application.routes.draw do
  devise_for :users
  # TODO: remove these two
  resources :children do
    post :active
  end
  resources :families

  resources :authorized_family_members
  devise_for :partners, controllers: { sessions: "partners/sessions" }
  devise_scope :partner do
    get "/partners/sign_out" => "devise/sessions#destroy"
  end

  resources :partners do
    get :approve
  end

  resources :partner_requests, only: [:new, :create, :show, :index]
  resources :family_requests, only: [:new, :create]

  get "/api", action: :show, controller: "api"
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :partners, only: [:create, :show, :update]
      # resource :partners, only: [:update]
    end
  end

  get(
    "/partners/sign_in",
    to: redirect("/users/sign_in")
  )

  get(
    "/partners/invitiation/accept?_inquiry_groups/:id/edit",
    to: redirect(path: "/users/invitation/accept")
  )

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "pages/:name", to: "static#page"
  root "static#index"
end
