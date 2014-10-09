class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :omniauthable,
         omniauth_providers: [
          :facebook,
          :twitter,
          :google_oauth2
          ]

  validates_uniqueness_of :username

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.username = date["name"] if user.username.blank?
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(email: data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(
        username: data["name"],
        email: data["email"],
        password: Devise.friendly_token[0,20]
        )
    end
    user
  end
end

  # after_create :send_email
  # def send_email
  #   UserMailer.welcome_email(self).deliver
  # end

  # def apply_omniauth(omniauth)
  #   identities.build(provider: omniauth['provider'], uid: omniauth['uid'])
  # end

  # def password_required?
  #   (identities.empty? || !password.blank?) && super
  # end

  # def update_with_password(params)
  #   update_attributes(user_params)
  # end
