Rails.application.routes.draw do

  root 'registrations#index'
  post 'register', to: 'registrations#create'

end
