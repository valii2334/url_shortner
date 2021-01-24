Rails.application.routes.draw do
  resources :short_urls

  root to: 'home#home'
end
