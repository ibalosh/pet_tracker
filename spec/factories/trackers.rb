FactoryBot.define do
  factory :tracker do
    pet { nil }
    tracker_type { nil }
    lost_tracker { false }
    in_zone { false }
  end
end
