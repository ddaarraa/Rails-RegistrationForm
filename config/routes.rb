Rails.application.routes.draw do

  root to: "dashboard#index"
  get 'register', to: 'registrations#index' , as: 'register'
  post 'register', to: 'registrations#create'
  get 'update/:id', to: 'dashboard#update', as: 'update'
  delete 'delete/:id', to: 'dashboard#delete' , as: "custom_delete"
  patch  '/update/:id', to: 'dashboard#update_action', as:"update_action"
end
