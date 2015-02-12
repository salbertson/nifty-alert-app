Rails.application.routes.draw do
  root to: "application#index"

  resources :alerts, only: [:create]
end
