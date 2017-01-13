module AuthenticationHelper
  def sign_in(profile)
    header('Authorization', "Token token=\"#{profile.authentication_token}\", email=\"#{profile.email}\"")
  end
end