class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :status, :published_at, :likes_count, :comments_count

  belongs_to :user
  has_many :tags
  has_many :comments, if: -> { object.comments.approved.any? } do
    object.comments.approved
  end

  def likes_count
    object.likes.count
  end

  def comments_count
    object.comments.approved.count
  end

  def published_at
    object.created_at
  end
end
