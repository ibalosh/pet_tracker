class CreateSpecies < ActiveRecord::Migration[8.0]
  def change
    create_table :species do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :species, :name, unique: true
  end
end
