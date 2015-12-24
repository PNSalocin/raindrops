# Gestion des routes de l'application
Raindrops::Engine.routes.draw do
  resources :downloads, only: [:index, :create, :destroy]
end
