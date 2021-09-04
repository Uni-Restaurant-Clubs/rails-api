class OauthService
  include HTTParty

  # uncomment this when want to debug
  #debug_output $stdout

  def self.get_token_from_code(params, provider)
		options = {
  		body: {
        code: params[:authorization_code],
        grant_type: "authorization_code",
        redirect_uri: ENV["#{provider}_REDIRECT_URI"],
        client_id: ENV["#{provider}_CLIENT_ID"],
        client_secret: ENV["#{provider}_CLIENT_SECRET"]
  		}
		}

    url = ENV["#{provider}_AUTHORIZATION_URL"]
    self.post(url, options)
  end

  def self.get_user_info(token_info, provider)
    if provider == "GOOGLE"
      token = token_info["access_token"]
    elsif provider == "FACEBOOK"
      token = token_info["accessToken"]
    end
    url = ENV["#{provider}_API_URI"]
    headers = {
      "Authorization" => "Bearer " + token,
      "Accept" => "application/json"
    }
    self.get(url, headers: headers)
  end

  def self.get_token_and_user_info(params)
    provider = params[:provider].upcase
    if params[:authorization_code]
      token_info = self.get_token_from_code(params, provider)
    else
      token_info = self.token_parameters(params)
    end
    return token_info, self.get_user_info(token_info, provider).deep_symbolize_keys
  end

  private

    def self.token_parameters(params)
      params.require(:tokenField).permit(
        :accessToken,
        :grantedScopes,
        :userID
      ).to_h
    end

end
