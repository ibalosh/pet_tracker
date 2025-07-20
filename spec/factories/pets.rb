FactoryBot.define do
  factory :pet do
    name { Faker::Creature::Animal.name }
    owner { nil }
    species { nil }
  end
end
