Rails.application.routes.draw do
  default_url_options host: ENV.fetch('HOST')

  devise_for :users, path: 'api/users', module: 'api'
  namespace :api do
    get 'districts/current', to: 'districts#show', as: :current_district
    resources :student_labels, only: :index
    resource :translations, only: :show
  end

  root to: 'client#show'
  get '*path', to: 'client#show', constraints: { format: :html }
end
