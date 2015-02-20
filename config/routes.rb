Spree::Core::Engine.add_routes do
  post '/paypal_adaptive', :to => "paypal_adaptive#adaptive", :as => :paypal_adaptive
  get '/paypal_adaptive/confirm', :to => "paypal_adaptive#confirm", :as => :confirm_paypal_adaptive
  get '/paypal_adaptive/cancel', :to => "paypal_adaptive#cancel", :as => :cancel_paypal_adaptive
    
  namespace :admin do
    # Using :only here so it doesn't redraw those routes
    resources :orders, :only => [] do
      resources :payments, :only => [] do
        member do
          get 'paypal_adaptive_refund'
          post 'paypal_adaptive_refund'
        end
      end
    end
  end
end
