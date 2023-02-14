FactoryBot.define do
  factory :nice_class do
    number { Faker::Number.unique.between(from: 1, to: 45) }
    short_description { "MyText" }
    explanatory_note { "MyText" }
  end
end
