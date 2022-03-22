# frozen_string_literal: true

# TODO: Add edit route
# TODO: Add controller module support ex: to: 'api/items#index'
# TODO: Replace MiniActiveRouter::Base to MiniRails.config
# TODO: add handler for controller
MiniActiveRouter::Base.instance.draw do
  get '/', to: 'home#index'

  # Group scope
  post '/groups', to: 'groups#create'
  delete '/groups/:id', to: 'groups#destroy'

  # Items scope
  get '/groups/:group_id/items', to: 'items#index'
  post '/groups/:group_id/items', to: 'items#create'
  delete '/groups/:group_id/items/:id', to: 'items#destroy'

  not_found to: 'not_found#index'
end
