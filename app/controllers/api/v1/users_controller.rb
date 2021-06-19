class Api::V1::UsersController < Api::V1::ApiApplicationController

  def create
    user_data = {
      email: params[:user][:email],
      password: params[:user][:password],
      password_confirmation: params[:user][:password],
    }
    user = User.new(user_data)

    if user.save
      render json: {}, status: 204
    else
      json = { error: true, message: user.errors.full_messages }.to_json
      render json: json, status: :bad_request
    end

  end

end
