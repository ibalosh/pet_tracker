FactoryBot.define do
  factory :tracker_type do
    sequence(:category) { |n| "Tracker #{n}" }
    species
  end
end
