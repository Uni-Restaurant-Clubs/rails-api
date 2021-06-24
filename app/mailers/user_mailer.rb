class UserMailer < ApplicationMailer

  def send_confirmation_email
    @user = params[:user]
    @confirm_url = confirm_email_api_v1_users_url(@user.confirmation_token)

    mail to: @user.email, subject: "Please confirm your email address."
  end
end
