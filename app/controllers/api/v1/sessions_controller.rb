class Api::V1::SessionsController < Api::V1::ApiApplicationController

  def create
    email = params[:email].strip rescue nil
    password = params[:password]
    user = User.find_by(email: email)
    if !email || !password
      json = { error: true, message: "Password and email required" }.to_json
      render json: json, status: 400
    elsif !user
      json = { error: true, message: "user with email not found" }.to_json
      render json: json, status: 404
    elsif !user.confirmed_at
      json = { error: true, message: "user must confirm email first" }.to_json
      render json: json, status: 410
    elsif user.locked_at
      message = "Your account is locked. You must reset your password to continue"
      json = { error: true, message: message }.to_json
      render json: json, status: 401
    elsif !user.valid_password?(password)
      user.failed_attempts = user.failed_attempts + 1
      message = "Email and password do not match."
      if user.failed_attempts >= 5
        user.locked_at = Time.now
        message = "Email and password do not match. Your account is now locked."+
                  " Please reset password to regain access"

      end
      user.save!
      json = { error: true, message: message }.to_json
      render json: json, status: 403
    else
      session = Session.new(user_id: user.id,
                            last_used: Time.now,
                            token: Session.create_new_token
                           )
      session.save!
      render json: { session_token: session.token }, status: 200
    end
  end

  def destroy
    token = params[:id]
    session = Session.find_by(token: token)
    if session
      session.destroy
    end
    render json: {}, status: 204
  end

end
