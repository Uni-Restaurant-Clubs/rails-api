class Recaptcha
  include HTTParty

  def self.get_code(token)

		options = {
  		body: {
        response: token,
        secret: ENV["RECAPTCHA_SECRET"]
  		}
		}

    url = "https://www.google.com/recaptcha/api/siteverify"
    self.post(url, options)
  end

end
