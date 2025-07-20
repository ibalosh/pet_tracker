class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.references :species, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
