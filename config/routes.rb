Rails.application.routes.draw do
  flipper_app = Flipper::UI.app(Flipper.instance) do |builder|
    builder.use Rack::Auth::Basic do |username, password|
      username == ENV["FLIPPER_USERNAME"] && password == ENV["FLIPPER_PASSWORD"]
    end
  end
  mount flipper_app, at: "/flipper"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    invitations: "users/invitations"
  }
  # TODO: remove these two
  resources :children do
    post :active
  end
  resources :families

  resources :authorized_family_members
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end

  get(
    "/partners/sign_in",
    to: redirect("/users/sign_in")
  )

  get(
    "/partners/invitiation/accept?_inquiry_groups/:id/edit",
    to: redirect(path: "/users/invitation/accept")
  )

  get "dashboard", to: "dashboard#index"

  resources :partners do
    get :approve
  end

  resources :users, only: [:index]
  resources :partner_requests, only: [:new, :create, :show, :index]
  resources :family_requests, only: [:new, :create] do
    resource :pickup_sheets, only: :show
  end

  post "/child_item_requests_toggle_picked_up/:id", action: :toggle_picked_up,
                                                    controller: :child_item_requests,
                                                    as: :child_item_requests_toggle_picked_up
  post "/child_item_requests_quantity_picked_up/:id",
       action: :quantity_picked_up,
       controller: :child_item_requests,
       as: :child_item_requests_quantity_picked_up
  post "/child_item_requests_item_picked_up/:id",
       action: :item_picked_up,
       controller: :child_item_requests,
       as: :child_item_requests_item_picked_up
  post "/child_item_requests_authorized_family_member_picked_up/:id",
       action: :authorized_family_member_picked_up,
       controller: :child_item_requests,
       as: :child_item_requests_authorized_family_member_picked_up

  get "/api", action: :show, controller: "api"
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :partners, only: [:create, :show, :update]
      resources :add_partners, only: [:create]
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "pages/:name", to: "static#page", as: "static_page"
  root "static#index"
end
