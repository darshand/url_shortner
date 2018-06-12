Rails.application.routes.draw do
  get 'web_page/home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :url
end
