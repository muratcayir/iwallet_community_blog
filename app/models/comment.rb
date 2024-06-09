class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy

  validates :content, presence: true
  validates :status, inclusion: { in: %w[pending approved rejected] }

  scope :approved, -> { where(status: 'approved') }
  scope :pending, -> { where(status: 'pending') }
  scope :rejected, -> { where(status: 'rejected') }
end
