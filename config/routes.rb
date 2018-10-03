Rails.application.routes.draw do
  devise_for :partners
  # resources :partners do
  #   collection do
  #     post :register
  #   end
  # end

  get '/api', action: :show, controller: 'api'
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :partners
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
