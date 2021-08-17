class Api::V1::OauthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def connect
    params[:provider] = get_provider
    token_info, user_info = OauthService.get_token_and_user_info(params)
    binding.pry
    #identity = Identity.find_or_create_with_user_info(info, params[:provider])

    user = User.new
    user.email = "test" + rand(1..1000000).to_s + "@gmail.com"
    user.save(validate: false)
    session = Session.new(user_id: user.id,
                          last_used: Time.now,
                          token: Session.create_new_token
                         )
    session.save!
    render json: { session_token: session.token }, status: 200

  end

  private

    def get_provider
      @provider = request.env['PATH_INFO'].split("/api/v1/oauth/")[1]
    end

end
