class Api::V1::UsersController < Api::V1::ApiApplicationController

  before_action :authenticate_api_user!, only: [:send_confirm_uni_email]

  def create
    user_data = {
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password],
    }
    user = User.new(user_data)
    user.confirmation_token = User.create_new_token("confirmation_token")
    user.confirmation_sent_at = Time.now

    if user.save
      UserMailer.with(user: user).send_confirmation_email.deliver_later
      render json: {}, status: 204
    else
      json = { error: true, message: user.errors.full_messages }.to_json
      render json: json, status: 400
    end
  end

  def passwordless_signin_email
    user = User.find_or_initialize_by(email: params[:email]&.strip&.downcase)
    user.passwordless_email_code = User.create_passwordless_email_code
    user.passwordless_email_code_sent_at = Time.now
    user.confirmation_token = User.create_new_token("confirmation_token")
    user.confirmation_sent_at = Time.now

    if user.save
      UserMailer.with(user: user).send_passwordless_email_code.deliver_later
      render json: { confirmation_token: user.confirmation_token }, status: 200
    else
      json = { error: true, message: user.errors.full_messages }.to_json
      render json: json, status: 400
    end
  end

  def passwordless_signin_confirm
    token = params[:confirmation_token]
    code = params[:code]
    user = User.find_by(confirmation_token: token,
                        passwordless_email_code: code)

    error = false
    status = 200
    if !token || !code || !user
      error = "token invalid"
      status = 400
    elsif expired = Time.now.to_i > (user.confirmation_sent_at + 15.minutes).to_i
      error = "token expired"
      status = 401
    elsif expired = Time.now.to_i > (user.passwordless_email_code_sent_at + 15.minutes).to_i
      error = "token expired"
      status = 401
    end

    if error
      json = { error: true, message: error }.to_json
      render json: json, status: status
    else
      user.passwordless_email_code = nil
      user.passwordless_email_code_sent_at = nil
      user.confirmation_token = nil
      user.confirmation_sent_at = nil
      user.save!
      session = Session.new(user_id: user.id,
                            last_used: Time.now,
                            token: Session.create_new_token
                           )
      session.save!
      render json: { session_token: session.token }, status: 200
    end
  end

  def send_confirm_uni_email

    user = @current_user
    error = false
    code = 204
    if !params[:email]
      error = "email required"
      code = 400
    end

    if error
      json = { error: true, message: error }.to_json
      render json: json, status: code
    else
      user.pending_uni_email = params[:email]
      user.confirm_uni_email_token = User.create_new_token("confirm_uni_email_token")
      user.confirm_uni_email_sent_at = Time.now
      user.save!
      UserMailer.with(user: user).send_confirm_uni_email.deliver_later
      render json: {}, status: 204
    end
  end

  def confirm_uni_email
    token = params[:token]
    user = User.find_by(confirm_uni_email_token: token)

    error = false
    if !token || !user
      error = "token invalid"
    elsif expired = Time.now.to_i > (user.confirm_uni_email_sent_at +
                                     7.days).to_i
      error = "token expired"
    end

    if error
      redirect_to "#{ENV["FRONTEND_WEB_URL"]}?error=#{error}"
    else
      user.uni_email_confirmed_at = Time.now
      user.uni_email = user.pending_uni_email
      user.confirm_uni_email_token = nil
      user.pending_uni_email = nil
      user.confirm_uni_email_sent_at = nil
      user.save!
      redirect_to ENV["FRONTEND_WEB_URL"] +
                    "?uni_email_confirmed=true"
    end
  end

  def resend_confirm_email
    user = User.find_by(email: params[:email])

    error = false
    code = 204
    if !params[:email]
      error = "email required"
      code = 400
    elsif !user
      error = "no user with that email"
      code = 404
    elsif user.confirmed_at
      error = "user already confirmed"
      code = 410
    end

    if error
      json = { error: true, message: error }.to_json
      render json: json, status: code
    else
      user.confirmation_token = User.create_new_token("confirmation_token")
      user.confirmation_sent_at = Time.now

      user.save!
      UserMailer.with(user: user).send_confirmation_email.deliver_later
      render json: {}, status: 204
    end

  end

  def confirm_email
    token = params[:token]
    user = User.find_by(confirmation_token: token)

    error = false
    if !token || !user
      error = "token invalid"
    elsif expired = Time.now.to_i > (user.confirmation_sent_at + 7.days).to_i
      error = "token expired"
    elsif user.confirmed_at
      error = "already confirmed"
    end

    if error
      redirect_to "#{ENV["FRONTEND_WEB_URL"]}/login/?error=#{error}"
    else
      user.confirmed_at = Time.now
      user.confirmation_token = nil
      user.confirmation_sent_at = nil
      user.save!
      redirect_to ENV["FRONTEND_WEB_URL"] +
                    "/login?email_confirmed=true"
    end
  end

  def send_password_reset_email
    email = params[:email]
    user = User.find_by(email: email)

    if !user
      json = { error: true,
               message: "there is no user with that email" }.to_json
      render json: json, status: 404
    else
      user.reset_password_confirm_email_token =
        User.create_new_token("reset_password_confirm_email_token")
      user.reset_password_confirm_email_token_sent_at = Time.now

      user.save!
      UserMailer.with(user: user).send_reset_password_confirmation_email.deliver_later
      render json: {}, status: 204
    end

  end

  def initiate_password_reset
    token = params[:token]
    user = User.find_by(reset_password_confirm_email_token: token)
    expired = (user.reset_password_confirm_email_token_sent_at + 2.hours).to_i < Time.now.to_i if user
    error = false
    if !token || !user
      error = "token invalid"
    elsif expired
      error = "token expired"
    end

    if error
      redirect_to "#{ENV["FRONTEND_WEB_URL"]}/login?error=#{error}"
    else
      user.confirmed_at = Time.now unless user.confirmed_at
      user.confirmation_token = nil
      user.reset_password_confirm_email_token = nil
      user.reset_password_confirm_email_token_sent_at = nil
      user.reset_password_token = User.create_new_token("reset_password_token")
      user.reset_password_sent_at = Time.now
      user.save!
      redirect_to "#{ENV["FRONTEND_WEB_URL"]}/enter_new_password"+
        "?token=#{user.reset_password_token}"
    end
  end

  def update_password
    token = params[:token]
    user = User.find_by(reset_password_token: token)
    password = params[:password]
    psw_invalid = password.blank? || (password.length < 6)

    error = false
    code = 204
    if !token || !user
      error = "token invalid"
      code = 403
    elsif expired = Time.now.to_i > (user.reset_password_sent_at + 2.hours).to_i
      error = "token expired"
      code = 410
    elsif psw_invalid
      error = "password needs to be at least 6 characters"
      code = 400
    end

    if error
      json = { error: true, message: error }.to_json
      render json: json, status: 400
    else
      user.failed_attempts = 0
      user.locked_at = nil
      user.reset_password_token = nil
      user.reset_password_sent_at = nil
      user.password = params[:password]
      user.save!
      render json: {}, status: 204
    end
  end

end
