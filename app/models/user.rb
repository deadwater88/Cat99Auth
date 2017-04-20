class User < ActiveRecord::Base
  validates :user_name, :password_digest, presence: true
  validates :session_token, :user_name, uniqueness: true
  validates :password, length: {minimum: 6}, allow_nil: true

  before_validation :ensure_session_token

  attr_reader :password

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    session_token = User.generate_session_token
    self.update(session_token: session_token)
    session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    if user.is_password?(password)
      return user
    else
      user.errors[:user_name] = "Username or Password does not match"
    end
  end

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat

  has_many :requests,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :CatRentalRequest

end
