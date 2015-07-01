Rails.application.routes.draw do
  default_url_options host: ENV.fetch('HOST')

  namespace :api do
    get 'districts/current', to: 'districts#show', as: :current_district
  end

  root to: 'client#show'
  get '*path', to: 'client#show', constraints: { format: :html }
end
