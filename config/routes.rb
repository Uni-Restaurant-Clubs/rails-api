Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:create] do
          collection do
            # CONFIRM EMAIL ADDRESS
            get 'confirm_email/:token', to: "users#confirm_email",
                 as: :confirm_email
            post 'resend_confirm_email/:token', to: "users#resend_confirm_email",
                 as: :resend_confirm_email

            # PASSWORD RESET
            # User has entered email. We send email to confirm
            post 'send_password_reset_email',
                 to: "users#send_password_reset_email",
                 as: :send_password_reset_email
            # User has confirmed email so we can now initiate password reset
            get 'initiate_password_reset', to: "users#initiate_password_reset",
                 as: :initiate_password_reset
            # User has submitted a new password
            post '', to: "users#update_password",
                 as: :update_password
          end
      end
    end
  end
end
