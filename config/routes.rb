Rails.application.routes.draw do
  devise_for :artists

  namespace :api, :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ } do
    resource :session, only: [:create, :destroy]
  end
end
