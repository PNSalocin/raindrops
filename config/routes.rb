Raindrops::Engine.routes.draw do

  root 'home#index'
  get '/threads', to: 'home#threads'

end
