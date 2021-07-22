class OauthService
=begin
  include HTTParty

  # uncomment this when want to debug
  #debug_output $stdout

  def self.get_token_from_code(params, provider)
		options = {
  		body: {
        code: params[:code],
        grant_type: "authorization_code",
        redirect_uri: ENV["APP_HOST"] + "/#{params[:provider]}/",
        client_id: ENV["#{provider}_CLIENT_ID"]
  		}
		}

    self.post(ENV["#{provider}_AUTHORIZATION_URL"], options)
  end

  def self.get_user_info(token_info, provider)
    url = ENV["#{provider}_PATIENT_URL"] + token_info["patient"]
    headers = {
      "Authorization" => "Bearer " + token_info["access_token"],
      "Accept" => "application/json"
    }
    self.get(url, headers: headers)
  end

  def self.get_token_and_user_info(params)
    provider = params[:provider].upcase
    token_info = self.get_token_from_code(params, provider)
    self.get_user_info(token_info, provider).deep_symbolize_keys
  end
=end

end
