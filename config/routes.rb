Rails.application.routes.draw do
  default_url_options(
    host: ENV.fetch('APPLICATION_HOST'),
    tld_length: ENV.fetch('APPLICATION_HOST').split('.').size
  )

  namespace :api do
    resources :sessions, only: :create
    resources :registrations, only: :create
    resources :confirmations, only: :create
    resources :password_resets, only: [:show, :create, :update]
    get 'users/current', to: 'users#show', as: :current_user
    put 'users/:ignored', to: 'users#update', as: :update_current_user
    resources :students, only: [:index, :create]
    resource :translations, only: :show

    namespace :v0 do
      resources :assignments, only: [:show, :create]
    end
  end

  root to: 'client#show'
  get ':anything', to: 'client#show', constraints: { anything: /(?!api).+/ }
end
