Rails.application.routes.draw do
  get 'pages/index'
  get 'pages/resume'
  get 'pages/projects'
  get 'pages/contact'

  get "up" => "rails/health#show", as: :rails_health_check

  # Definir la ruta raíz
  root "pages#index"
end
