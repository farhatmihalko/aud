Sozdik::Application.routes.draw do

  get "sessions/new"

  get "users/new"

  resources :adverts

  get "home/index"

  root :to => "words#index"

  match 'words/similar/:lang/:word' => 'words#similar'

  match 'translate/ru/kk/words/suggest/:lang/:name' => 'words#suggest'
  match 'translate/kk/ru/words/suggest/:lang/:name' => 'words#suggest'
  match 'translate/kk/ru/words/:lang/:name' => 'words#define', :as => :word_definition
  match 'translate/ru/kk/words/:lang/:name' => 'words#define', :as => :word_definition
  match 'words/word_exist' => 'words#word_exist', via: :post
  match 'words/add_word' => 'words#create', via: :post
  match 'words/lemmatize/:word' => 'words#lem'
  match 'words/:lang/:name' => 'words#define', :as => :word_definition
  match 'api/define/:lang/:name' => 'api#define'
  match 'api/words' => 'api#words'
  match 'api' => 'api#index'
  match 'words/suggest/:lang/:name' => 'words#suggest'
  match 'contact_us' => 'words#contact_us'
  match 'about_us' => 'words#about_us'
  match 'examples' => 'words#examples'
  match 'api/index/:word' => 'api#indexed_name'
  match 'adverts/destroy/:id' => 'adverts#destroy'

  match 'api/parse/:lang/:name' => 'api#parse'

  match 'catalog' => 'words#catalog'
  match 'catalog/:lang' => 'words#catalog'
  match 'catalog/:lang/:letter' => 'words#catalog'
  match 'catalog/:lang/:letter/:page' => 'words#catalog'
  match 'api/find_syn' => 'api#find_syn'
  match 'api/find_abbr' => 'api#find_abbr'

  match 'words/nearby/:lang/:name' => 'words#nearby'
  match 'random/:lang' => 'words#random'

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  resources :users
  resources :sessions

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
