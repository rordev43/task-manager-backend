Rails.application.routes.draw do
  namespace :api do
    resources :tasks do
      member do
        post :assign
        put :progress
      end
      collection do
        get :overdue
        get 'status/:status', action: :status, as: :tasks_by_status
        get :completed
        get :statistics
      end
    end
  
    resources :users, only: [] do
      resources :tasks, only: :index
    end
  end
end
