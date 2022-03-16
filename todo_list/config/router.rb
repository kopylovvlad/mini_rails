# frozen_string_literal: true

# TODO: add edit route
MiniActiveRouter.instance.draw do
  get '/', to: 'items#index'
  post '/items', to: 'items#create'
  delete '/items/:id', to: 'items#destroy'
  not_found to: 'not_found#index'
end
