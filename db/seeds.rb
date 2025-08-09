puts "Cleaning database..."
Tracker.destroy_all
Pet.destroy_all
Owner.destroy_all
TrackerType.destroy_all
Species.destroy_all

puts "Creating owners..."
owners = 10.times.map do |i|
  Owner.create!(name: Faker::Name.name, email: Faker::Internet.email)
end

puts "Creating species..."
cat = Species.create!(name: "Cat")
dog = Species.create!(name: "Dog")

puts "Creating tracker types..."
cat_tracker_types = %w[small large].map do |category|
  TrackerType.create!(category: category, species: cat)
end

dog_tracker_types = %w[small medium large].map do |category|
  TrackerType.create!(category: category, species: dog)
end

puts "Creating pets..."
pets = []

owners.each_with_index do |owner, i|
  species = i.even? ? cat : dog
  2.times do |j|
    pets << Pet.create!(
      name: "#{species.name} #{i}-#{j}",
      species: species,
      owner: owner
    )
  end
end

puts "Creating trackers..."
pets.each_with_index do |pet, i|
  tracker_type =
    if pet.species.name == "Cat"
      cat_tracker_types.sample
    else
      dog_tracker_types.sample
    end

  Tracker.create!(
    pet: pet,
    tracker_type: tracker_type,
    lost_tracker: pet.species.name == "Cat" ? [ true, false ].sample : false,
    in_zone: i % 3 != 0 # Some pets out of zone
  )
end

puts "Done seeding ✅"
