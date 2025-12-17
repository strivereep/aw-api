FactoryBot.define do
  factory :content do
    title { Faker::Lorem.word }
    body { Faker::Lorem.sentence }
  end
end
