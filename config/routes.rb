Raindrops::Engine.routes.draw do
  root to: 'downloads#index'
  resources :downloads, only: [:index, :create, :destroy]
  get 'downloads/events', to: 'downloads#events'
end
