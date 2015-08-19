ImgUpload::Application.routes.draw do
  root to: 'examples#index'
  resources :examples
  resources :photos
end
