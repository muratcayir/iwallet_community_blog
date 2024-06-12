# spec/models/article_spec.rb

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { User.create!(username: 'testuser', email: 'test@example.com', password: 'password') }

  it 'is valid with valid attributes' do
    article = Article.new(title: 'Valid Title', content: 'Valid Content', user:)
    expect(article).to be_valid
  end

  it 'is not valid without a title' do
    article = Article.new(content: 'Content without title', user:)
    expect(article).to_not be_valid
  end

  it 'is not valid with a title longer than 140 characters' do
    long_title = 'a' * 141
    article = Article.new(title: long_title, content: 'Valid Content', user:)
    expect(article).to_not be_valid
  end

  it 'returns only published articles' do
    draft_article = Article.create!(title: 'Draft Title', content: 'Draft Content', status: 'draft', user:)
    published_article = Article.create!(title: 'Published Title', content: 'Published Content', status: 'published',
                                        user:)
    expect(Article.published).to include(published_article)
    expect(Article.published).to_not include(draft_article)
  end

  it 'belongs to a user' do
    assoc = Article.reflect_on_association(:user)
    expect(assoc.macro).to eq :belongs_to
  end

  it 'has many comments' do
    assoc = Article.reflect_on_association(:comments)
    expect(assoc.macro).to eq :has_many
  end

  it 'has many tags through taggings' do
    assoc = Article.reflect_on_association(:tags)
    expect(assoc.macro).to eq :has_many
    expect(assoc.options[:through]).to eq(:taggings)
  end
end
