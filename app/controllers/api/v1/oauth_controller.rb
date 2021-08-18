class Api::V1::OauthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def connect
    params[:provider] = get_provider
    token_info, user_info = OauthService.get_token_and_user_info(params)
    binding.pry
    identity = Identity.find_or_create_with_user_info(info, params[:provider])

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

=begin
Google response
=> {"access_token"=>"ya29.a0ARrdaM84IAPBqvsxU3Whr0s7w2JUuPAfYkeUaVZ0RKb0n1w1zsmWChEb6z4TCkWw5LktojNXbKrbl0TRvXxjYZyAGTxP8BiBkzW6yBZE9pl5tZFc-a8TkJWS_XHkx1ztwI7tCyWtf_CjnQmcVBaWpHeE9Iiu",
 "expires_in"=>3597,
 "refresh_token"=>"1//06clpaBk-3XpOCgYIARAAGAYSNwF-L9IrWwzAM9rVGnM62bI3bfIjlK3VJ5b2yuUqPy4pY5wvU9eVawNnXBiSA-lqhDtGD7Gi0N4",
 "scope"=>"openid https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email",
 "token_type"=>"Bearer",
 "id_token"=>
  "eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ2Mjk0OTE3NGYxZWVkZjRmOWY5NDM0ODc3YmU0ODNiMzI0MTQwZjUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2MTEyNzEzNzU2MDYtNWVodG40cTZhcXY4bG1zYjNwcmNsYTlyMDFrdW52Mm0uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2MTEyNzEzNzU2MDYtNWVodG40cTZhcXY4bG1zYjNwcmNsYTlyMDFrdW52Mm0uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDc0NDAxNzIwMDI1ODYzMTUyODUiLCJlbWFpbCI6Im1vbnR5bGVubmllQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiMm44R1gxTEk2SWVvWjZ1UzRfeUlGQSIsIm5hbWUiOiJNb250eSBMZW5uaWUiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2hrTXpuaHk2a3NVbkpfN0pDQ1lzcWhXN0NEeFl0U3pvNWRlZEtBWVlrPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6Ik1vbnR5IiwiZmFtaWx5X25hbWUiOiJMZW5uaWUiLCJsb2NhbGUiOiJlbi1HQiIsImlhdCI6MTYyOTI1MDQ1OSwiZXhwIjoxNjI5MjU0MDU5fQ.FB05eE_azzwpZ99zQj0wgyPh4ABth0VHtQTD1HB6CtN1SEV9kWVSxeEIor0ZuvNiyHMnmwf-Rw8OxUCIUr2e9lGGhv0DKDMGADZ54Rsz8JvOsfm4HQChzKmcR58ZeTCabRU_Hoa63oTYJBGQMtac3nTIiZeDqNuF0UH6ucqyDSPYurwYjsuox0deObfrmyMlMlxfYrcajnOdZJv1NptwWhisAv69qMLLVv9YC46X0e6mvQeF0rs7NIyAQjTTZadfJzvy1wfh2USNbkrLPWchNGZjuHPHzHanhAChTaJRn0XQtStqxZr8OLTVOFVjpeYhpayOpio4gRUiG0EH8NxhYQ"}
[2] pry(#<Api::V1::OauthController>)> user_info
=> {:id=>"107440172002586315285",
 :email=>"montylennie@gmail.com",
 :verified_email=>true,
 :name=>"Monty Lennie",
 :given_name=>"Monty",
 :family_name=>"Lennie",
 :picture=>"https://lh3.googleusercontent.com/a-/AOh14GhkMznhy6ksUnJ_7JCCYsqhW7CDxYtSzo5dedKAYYk=s96-c",
 :locale=>"en-GB"}
=end

end
