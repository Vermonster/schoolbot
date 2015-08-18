Rails.application.routes.draw do
  default_url_options host: ENV.fetch('HOST')

  devise_for :users, skip: :all

  namespace :api do
    devise_scope :user do
      post 'users/sign_in', to: 'sessions#create', as: :user_session
    end
    get 'users/current', to: 'users#show', as: :current_user
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
