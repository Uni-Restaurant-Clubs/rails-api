class Api::V1::UsersController < Api::V1::ApiApplicationController

  def create
    user_data = {
      email: params[:user][:email],
      password: params[:user][:password],
      password_confirmation: params[:user][:password],
    }
    user = User.new(user_data)

    if user.save
      user.confirmation_token = User.create_new_token("confirmation_token")
      user.confirmation_sent_at = Time.now
      UserMailer.with(user: user).confirmation_email.deliver_later
      render json: {}, status: 204
    else
      json = { error: true, message: user.errors.full_messages }.to_json
      render json: json, status: :bad_request
    end
  end

  def send_password_reset_email
    email = params[:email]
    user = User.find_by(email: email)

    if !user
      json = { error: true,
               message: "there is no user with that email" }.to_json
      render json: json, status: 400
    else
      user.reset_password_confirm_email_token =
        User.create_new_token("reset_password_confirm_email_token")
      user.reset_password_confirm_email_token_sent_at = Time.now

      if user.save
        UserMailer.with(user: user).send_reset_password_confirmation_email.deliver_later
        render json: {}, status: 204
      else
        json = { error: true, message: user.errors.full_messages }.to_json
        render json: json, status: 400
      end
    end

  end

  def resend_confirm_email
    user = User.find_by(email: params[:email])

    error = false
    if !params[:email]
      error = "email required"
    elsif !user
      error = "no user with that email"
    elsif user.confirmed_at
      error = "user already confirmed"
    end

    if error
      json = { error: true, message: error }.to_json
      render json: json, status: 400
    else
      if user.save
        user.confirmation_token = User.create_new_token("confirmation_token")
        user.confirmation_sent_at = Time.now
        UserMailer.with(user: user).confirmation_email.deliver_later
        render json: {}, status: 204
      else
        json = { error: true, message: user.errors.full_messages }.to_json
        render json: json, status: :bad_request
      end
    end

  end

  def confirm_email
    token = params[:token]
    user = User.find_by(confirmation_token: token)
    expired = Time.now.to_i > (user.confirmation_sent_at + 7.days).to_i

    error = false
    if !token || !user
      error = "token invalid"
    elsif expired
      error = "token expired"
    elsif user.confirmed_at
      error = "already confirmed"
    end

    if error
      json = { error: true, message: error }.to_json
      render json: json, status: 400
    else
      user.confirmed_at = Time.now
      user.confirmation_token = nil
      user.confirmation_sent_at = nil
      if user.save
        render json: {}, status: 204
      else
        json = { error: true, message: user.errors.full_messages }.to_json
        render json: json, status: 500
      end
    end
  end

  def initiate_password_reset
    token = params[:token]
    user = User.find_by(reset_password_confirm_email_token: token)
    expired = Time.now.to_i > (user.reset_password_confirm_email_token_sent_at
                               + 2.hours).to_i

    error = false
    if !token || !user
      error = "token invalid"
    elsif expired
      error = "token expired"
    end

    #TODO: look up how to redirect to url
    if error
      redirect_to: ENV["FRONTEND_WEB_URL"] + "?error=#{error}"
    else
      user.reset_password_confirm_email_token = nil
      user.reset_password_confirm_email_token_sent_at = nil
      user.reset_password_token = User.create_new_token("reset_password_token")
      user.reset_password_sent_at = Time.now
      if user.save
        redirect_to: ENV["FRONTEND_WEB_URL"] + "?token=#{user.reset_password_token}"
      else
        redirect_to: ENV["FRONTEND_WEB_URL"] + "?error=could not update user"
      end
    end
  end

  def update_password
    token = params[:token]
    user = User.find_by(reset_password_token: token)
    expired = Time.now.to_i > (user.reset_password_sent_at + 2.hours).to_i

    error = false
    if !token || !user
      error = "token invalid"
    elsif expired
      error = "token expired"
    elsif !params[:password] || params[:password].count < 6
      error = "password needs to be at least 6 characters"
    end

    if error
      json = { error: true, message: error }.to_json
      render json: json, status: 400
    else
      user.reset_password_token = nil
      user.reset_password_sent_at = nil
      # TODO: look up how to update password
      user.password = params[:password]
      if user.save
        render json: {}, status: 204
      else
        json = { error: true, message: user.errors.full_messages }.to_json
        render json: json, status: 500
      end
    end
  end

end
