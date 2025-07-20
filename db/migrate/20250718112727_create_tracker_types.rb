class CreateTrackerTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :tracker_types do |t|
      t.references :species, null: false, foreign_key: true
      t.string :category, null: false

      t.timestamps
    end

    add_index :tracker_types, [ :species_id, :category ], unique: true
  end
end
