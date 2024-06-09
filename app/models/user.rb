class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: { case_sensitive: false }

  before_validation :set_default_username, on: :create

  private
  
  def set_default_username
    if self.username.blank?
      base_username = email.split('@').first
      self.username = base_username
      suffix = 1

      while User.exists?(username: self.username)
        self.username = "#{base_username}#{suffix}"
        suffix += 1
      end
    end
  end
end
