Raindrops::Engine.routes.draw do
  root to: 'downloads#index'
  resources :downloads, only: [:index, :create, :destroy]
  get 'downloads/progress', to: 'live#downloads_progress'
end
