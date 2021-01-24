Rails.application.routes.draw do
  resources :short_urls

  get '/s/:random_hex', to: 'short_urls#search', as: :short_url_generator

  root to: 'home#home'
end
