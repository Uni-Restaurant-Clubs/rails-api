class UserMailer < ApplicationMailer

  def send_confirmation_email
    @user = params[:user]
    @confirm_url = confirm_email_api_v1_users_url(@user.confirmation_token)

    mail to: @user.email, subject: "Please confirm your email address."
  end

  def send_reset_password_confirmation_email
    @user = params[:user]
    @confirm_url = send_password_reset_email_api_v1_users_url(
                                      @user.reset_password_confirm_email_token)

    mail to: @user.email, subject: "Confirm your password reset request"
  end

end
