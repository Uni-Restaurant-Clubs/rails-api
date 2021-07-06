class UserMailer < ApplicationMailer

  def send_confirmation_email
    @user = params[:user]
    @confirm_url = confirm_email_api_v1_users_url(@user.confirmation_token)

    mail to: @user.email, subject: "Please confirm your email address."
  end

  def send_reset_password_confirmation_email
    @user = params[:user]
    @confirm_url = initiate_password_reset_api_v1_users_url(
                                      @user.reset_password_confirm_email_token)

    mail to: @user.email, subject: "Confirm your password reset request"
  end

  def send_confirm_uni_email
    @user = params[:user]
    @confirm_url = confirm_uni_email_api_v1_users_url(
      @user.confirm_uni_email_token)

    mail to: @user.pending_uni_email, subject: "Please confirm your email address."
  end

end
