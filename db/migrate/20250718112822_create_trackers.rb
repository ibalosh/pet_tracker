class CreateTrackers < ActiveRecord::Migration[8.0]
  def change
    create_table :trackers do |t|
      t.references :pet, null: false, foreign_key: true
      t.references :tracker_type, null: false, foreign_key: true
      t.boolean :lost_tracker, default: false
      t.boolean :in_zone, default: true

      t.timestamps
    end
  end
end
