ImgUpload::Application.routes.draw do
  root :to => 'photos#index'
  resources :photos
end
