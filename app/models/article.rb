class Article < ApplicationRecord
  has_rich_text :content

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :likes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 140 }
  validates :content, presence: true

  before_validation :set_default_content, on: %i[create update]

  enum status: { draft: 'draft', published: 'published' }
  scope :published, -> { where(status: 'published') }
  scope :draft, -> { where(status: 'draft') }

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= 'draft'
  end

  def truncated_title(length = 20)
    title.truncate(length)
  end

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def likes_count
    likes.count
  end

  def comments_count
    comments.count
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def set_default_content
    self.content = 'Content will be here' if content.blank?
  end
end
