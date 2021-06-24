class Api::V1::SessionsController < Api::V1::ApiApplicationController

  def create
    email = params[:email]
    password = params[:password]
    #TODO: use devise to validate password
    user = User.find_by(email: email, password: password)

    if !email || !password
      json = { error: true, message: "Password and email required" }.to_json
      render json: json, status: :bad_request
    elsif !user
      json = { error: true, message: "Email and password do not match" }.to_json
      render json: json, status: :bad_request
    else
      session = Session.new(user_id: user.id,
                            last_used: Time.now,
                            token: Session.create_new_token
                           )
      if session.save
        render json: { session_token: session.token }, status: 200
      else
        json = { error: true, message: user.errors.full_messages }.to_json
        render json: json, status: :bad_request
      end
    end
  end

  def destroy
    token = params[:token]
    session = Session.find_by(token: token)
    if session
      session.destroy
      render json: {}, status: 204
    else
      json = { error: true, message: "token doesn't exist" }.to_json
      render json: json, status: :bad_request
    end

  end

end
