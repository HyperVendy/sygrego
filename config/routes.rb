Rails.application.routes.draw do
  root 'admin/sports#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  } 

  namespace :admin do
    resource :info, :controller => "info" do
      collection do
        get :tech_stats
      end
    end

    resources :settings, only: [:show, :edit, :update] do
      member do
        get :edit_functionality
        get :edit_fees
        get :edit_divisions
        get :edit_sports_factors
        patch :update_functionality
        patch :update_fees
        patch :update_divisions
        patch :update_sports_factors
      end
    end
    resources :audit_trail, only: [:index]

    resources :sports
    resources :sessions do
      collection do
        get :new_import
        post :import
      end
    end
    resources :venues
  end
end
