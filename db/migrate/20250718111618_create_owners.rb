class CreateOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :owners do |t|
      t.string :name, null: false, limit: 200
      t.string :email, null: false, limit: 200

      t.timestamps
    end

    add_index :owners, :email, unique: true
  end
end
