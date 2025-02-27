SolidCableDashboard::Engine.routes.draw do
  resources :messages, only: [:index, :show] do
    collection do
      delete :clear_all
    end
    member do
      delete :delete
    end
  end

  resources :message_events, only: [:index]

  get "stats", to: "stats#index", as: :stats
  post "appearance/toggle", to: "appearance#toggle", as: :toggle_appearance

  root "dashboard#index"
end
