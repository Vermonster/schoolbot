Rails.application.routes.draw do
  default_url_options host: ENV.fetch('HOST')

  devise_for :users, path: 'api/users', module: 'api'
  namespace :api do
    get 'districts/current', to: 'districts#show', as: :current_district
    resources :students, only: :index
    resource :translations, only: :show

    namespace :v0 do
      resources :assignments, only: [:show, :create]
    end
  end

  root to: 'client#show'
  get ':anything', to: 'client#show', constraints: { anything: /(?!api).+/ }
end
