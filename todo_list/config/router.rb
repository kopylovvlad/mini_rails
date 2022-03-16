# frozen_string_literal: true

# TODO: add placeholders support in path
MiniActiveRouter.instance.draw do
  get '/', to: 'items#index'
  post '/', to: 'items#create'
  delete '/delete', to: 'items#destroy'
  not_found to: 'not_found#index'
end
