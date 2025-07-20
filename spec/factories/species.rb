FactoryBot.define do
  factory :species do
    sequence(:name) { |n| "Species #{n}" }
  end
end
