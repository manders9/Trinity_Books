class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :confirmable

  validates_uniqueness_of :username

  def apply_omniauth(omniauth)
    identities.build(provider: :omniauth['provider'], uid: :omniauth['uid'])
  end

  def password_required?
    (identities.empty? || !password.blank?) && super
  end

  def update_with_password(params, *options)
    update_attributes(params, *options)
  end
end
