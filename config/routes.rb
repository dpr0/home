# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  get  '/v1.0',                     to: 'users#index'
  get  '/v1.0/user/devices',        to: 'users#devices'
  post '/v1.0/user/unlink',         to: 'users#unlink'
  post '/v1.0/user/devices/query',  to: 'users#query'
  post '/v1.0/user/devices/action', to: 'users#action'

  resources :users
  resources :devices do
    resources :capabilities
  end

  root 'devices#index'
end
