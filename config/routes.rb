# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  get 'user', action: :show, controller: 'users'
  patch 'user', action: :update, controller: 'users'
  delete 'user', action: :destroy, controller: 'users'
end
