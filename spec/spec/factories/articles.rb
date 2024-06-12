FactoryBot.define do
  factory :article do
    title { 'Test Article' }
    content { 'This is a test article.' }
    status { 'draft' }
    association :user
  end
end
