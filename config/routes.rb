Rails.application.routes.draw do
  resources :short_urls, only: [:new, :create, :update]

  get '/s/:random_hex', to: 'short_urls#search', as: :short_url_generator

  root to: 'short_urls#new'
end
