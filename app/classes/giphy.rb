class Giphy

  def self.get_random(query="excited")
    url = "https://api.giphy.com/v1/gifs/random?" +
    "api_key=#{ENV["GIPHY_API_KEY"]}&" +
    "tag=#{query}&" +
    "rating=pg&"

    options = {}

    begin
      return HTTParty.get(url, options).parsed_response.deep_symbolize_keys
    rescue Exception => e
      Airbrake.notify("couldn't get Gif", {
        error: e
      })
      return { error: true, message: e }
    end
  end

end
