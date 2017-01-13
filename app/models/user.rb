class User < ActiveRecord::Base

  before_create :generate_authentication_token
  before_create :encrypt_password

  # API methods
  def verified_password? pass
    pass == crypt.decrypt_and_verify(self.password)
  end

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break unless User.find_by(authentication_token: authentication_token)
    end
  end

  def generate_new_authentication_token
    self.generate_authentication_token
    self.save
  end

  def encrypt_password
    self.password = crypt.encrypt_and_sign(password)
    self.password_confirmation = crypt.encrypt_and_sign(password)
  end

  private
  def crypt
    @crypt ||= ActiveSupport::MessageEncryptor.new(Rails.configuration.secret_key_base)
  end
end
