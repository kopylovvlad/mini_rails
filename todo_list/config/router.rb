# frozen_string_literal: true

# TODO: Add edit route
# TODO: Add controller module support ex: to: 'api/items#index'
# TODO: Replace MiniActiveRouter::Base to MiniRails.config
MiniActiveRouter::Base.instance.draw do
  get '/', to: 'items#index'
  post '/items', to: 'items#create'
  delete '/items/:id', to: 'items#destroy'
  not_found to: 'not_found#index'
end
