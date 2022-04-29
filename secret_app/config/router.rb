# frozen_string_literal: true

MiniActiveRouter::Base.instance.draw do
  get '/', to: 'home#index'

  post '/secrets', to: 'secrets#create'
  get '/secrets/:id', to: 'secrets#show'

  post '/api/secrets', to: 'api/secrets#create'
  get '/api/secrets/:id', to: 'api/secrets#show'

  not_found to: 'home#not_found'
end
