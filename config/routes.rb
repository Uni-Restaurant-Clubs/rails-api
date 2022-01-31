Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :creator_review_offers, only: [:edit, :update]
  resources :review_happened_confirmations, only: [:edit]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      # OAuth 2.0
      post 'oauth/facebook' => 'oauth#connect'
      post 'oauth/google' => 'oauth#connect'
      post 'oauth/apple' => 'oauth#connect'

      # Contact
      post 'contact' => 'contact#contact_form'

      resources :sessions, only: [:create, :destroy]
      resources :feature_periods, only: [:show]
      resources :reviews, only: [:show, :index] do
        collection do
          post 'scheduling_info', to: "reviews#create_scheduling_info"
        end
      end
      resources :check_ins, only: [:create]
      resources :log_events, only: [] do
        collection do
          post 'track', to: "log_events#track"
        end
      end
      resources :restaurants, only: [] do
        member do
          get 'info_for_scheduling_form', to: "restaurants#info_for_scheduling_form"
        end
      end
      resources :review_happened_confirmations, only: [] do
        member do
          get 'respond', to: "review_happened_confirmations#respond",
                 as: :respond
        end
      end
      resources :content_creators, only: [:show] do
          collection do
            # SUBMIT APPLICATION
            post 'submit_application', to: "content_creators#submit_application"
          end
      end
      resources :users, only: [:create] do
          collection do
            get 'current_user', to: "users#get_current_user"

            # START PASSWORDLESS SIGNIN
            post 'passwordless_signin_email', to: "users#passwordless_signin_email",
                 as: :passwordless_signin_email
            # PASSWORDLESS SIGNIN CODE CONFIRM
            post 'passwordless_signin_confirm',
                 to: "users#passwordless_signin_confirm",
                 as: :passwordless_signin_confirm
            # PASSWORDLESS SIGNIN CODE RESEND
            post 'resend_passwordless_code',
                 to: "users#resend_passwordless_signin_code",
                 as: :resend_passwordless_signin_code
            # CONFIRM EMAIL ADDRESS
            get 'confirm_email/:token', to: "users#confirm_email",
                 as: :confirm_email
            post 'resend_confirm_email', to: "users#resend_confirm_email",
                 as: :resend_confirm_email
            # CONFIRM UNI EMAIL ADDRESS
            get 'confirm_uni_email/:token', to: "users#confirm_uni_email",
                 as: :confirm_uni_email
            post 'send_confirm_uni_email', to: "users#send_confirm_uni_email",
                 as: :send_confirm_uni_email
            # PASSWORD RESET
            # User has entered email. We send email to confirm
            post 'send_password_reset_email',
                 to: "users#send_password_reset_email",
                 as: :send_password_reset_email
            # User has confirmed email so we can now initiate password reset
            get 'initiate_password_reset/:token',
                 to: "users#initiate_password_reset",
                 as: :initiate_password_reset
            # User has submitted a new password
            post 'update_password', to: "users#update_password",
                 as: :update_password
          end
      end
      ###########################################
      # STRIPE
      ###########################################
      resources :payments, only: [] do
        collection do
          post 'webhook', to: "payments#webhook",
               as: :payments_webhook
          post 'checkout', to: "payments#create_checkout_url",
               as: :create_checkout_url
          post 'customer_portal', to: "payments#create_portal_url",
               as: :payments_create_portal_url
        end
      end
    end
  end
end
