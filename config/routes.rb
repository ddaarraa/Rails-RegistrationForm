Rails.application.routes.draw do
  resources :users, only: [:index, :delete, :show, :edit, :update, :destroy]

  root 'registrations#index'
  get  "dashboard", to: "dashboard#index"
  post 'register', to: 'registrations#create'
  delete 'delete/:id', to: 'dashboard#delete' , as: "custom_delete"

end
