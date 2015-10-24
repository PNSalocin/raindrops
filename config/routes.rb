Raindrops::Engine.routes.draw do

  root to: 'downloads#index'

  resources :downloads, only: [:index, :create, :destroy]

end
