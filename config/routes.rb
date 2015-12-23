Raindrops::Engine.routes.draw do
  resources :downloads, only: [:index, :create, :destroy]
end