class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: { case_sensitive: false }

  before_validation :set_default_username, on: :create

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.name = auth.info.name
      user.username = auth.info.nickname
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def set_default_username
    return unless username.blank?

    base_username = email.split('@').first
    self.username = base_username
    suffix = 1

    while User.exists?(username:)
      self.username = "#{base_username}#{suffix}"
      suffix += 1
    end
  end
end
