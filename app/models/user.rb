class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: { case_sensitive: false }

  before_validation :set_default_username, on: :create

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(
      email: data['email'],
      password: Devise.friendly_token[0, 20]
    )
    user
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
