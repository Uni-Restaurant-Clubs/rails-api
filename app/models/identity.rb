class Identity < ApplicationRecord
  belongs_to :user

  validates_presence_of :user_id, :external_user_id, :provider
  validates_uniqueness_of :provider, scope: :external_user_id

  enum provider: { google: 0, facebook: 1, apple: 2 }

  def update_from_info(token_info, user_info, provider)
    identity_data = {
      first_name: user_info[:first_name],
      last_name: user_info[:last_name],
      picture: user_info[:picture],
      locale: user_info[:locale],
      access_token: token_info[:access_token],
      expires_at: token_info[:expires_at],
      refresh_token: token_info[:refresh_token],
      scope: token_info[:scope],
      token_type: token_info[:token_type],
      id_token: token_info[:id_token]
    }
    updated = self.update(identity_data)
    if updated
      return self
    else
      Airbrake.notify("identity couldn't update",
                      { user_info: user_info,
                        provider: provider,
                        token_info: token_info })
      return false
    end

  end

  def self.create_from_info(user_id, token_info, user_info, provider)
    identity_data = {
      user_id: user_id,
      external_user_id: user_info[:external_user_id],
      provider: provider,
      email: user_info[:email]&.downcase,
      verified_email: user_info[:verified_email],
      first_name: user_info[:first_name],
      last_name: user_info[:last_name],
      picture: user_info[:picture],
      locale: user_info[:locale],
      access_token: token_info[:access_token],
      expires_at: token_info[:expires_at],
      refresh_token: token_info[:refresh_token],
      scope: token_info[:scope],
      token_type: token_info[:token_type],
      id_token: token_info[:id_token]
    }
    identity = self.new(identity_data)
    if identity.save
      return identity
    else
      Airbrake.notify("identity couldn't be created",
                      { user_info: user_info,
                        user_id: user_id,
                        provider: provider,
                        token_info: token_info,
                        identity_errors: identity.errors.full_messages })
      return false
    end
  end

  def self.normalize_user_info(info, provider)
    if provider == "google"
      return {
        external_user_id: info[:id],
        email: info[:email],
        verified_email: info[:verified_email],
        first_name: info[:given_name],
        last_name: info[:family_name],
        picture: info[:picture],
        locale: info[:locale]
      }
    end
  end

  def self.normalize_token_info(info, provider)
    if provider == "google"
      return {
        access_token: info[:access_token],
        expires_at: Time.now + info[:expires_in].to_i&.seconds,
        refresh_token: info[:refresh_token],
        scope: info[:scope],
        token_type: info[:token_type],
        id_token: info[:id_token]
      }
    end
  end

  def self.find_or_create_with_user_info(token_info,
                                         user_info,
                                         provider)

    # Normalize data
    token_info.deep_symbolize_keys!
    user_info.deep_symbolize_keys!
    user_info = self.normalize_user_info(user_info, provider)
    token_info = self.normalize_token_info(token_info, provider)

    # Check for external_user_id and provider
    if !user_info[:external_user_id] || !provider
      Airbrake.notify("external_user_id or provider is missing",
                      { user_info: user_info,
                        token_info: token_info,
                        provider: provider})
      return nil
    end

    # search identity with provider and external_user_id
    identity = Identity.find_by(external_user_id: user_info[:external_user_id],
                                provider: provider)
    # if exists then update values and return identity
    if identity
      identity = identity.update_from_info(token_info, user_info, provider)
      return identity
    else
      # if no identity found then search for a user by email
      email = user_info[:email]
      if !email
        Airbrake.notify("oauth user_info has no email",
                        { user_info: user_info,
                          token_info: token_info,
                          provider: provider})
        return nil
      end
      user = User.find_by('lower(email) = ?', email&.downcase)
      if user
        # if user found then create new identity for that user
        identity = self.create_from_info(user.id, token_info, user_info, provider)
        return identity
      else
        # if no user found then create a user and an identity
        user = User.create_from_identity_info(user_info)
        return nil unless user
        identity = self.create_from_info(user.id, token_info, user_info, provider)
        return identity
      end
    end
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
