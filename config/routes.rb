Rails.application.routes.draw do
  resources :study_sets
  resources :folders

  post '/study_sets/:id/copy', to: "study_sets#copy"
  post '/study_sets/:id/sort', to: "study_sets#sort"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update, :destroy]
  root to: "study_sets#index"

#  devise_scope :user do
#    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
#  end
end
