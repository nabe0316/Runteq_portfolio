class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username, null: false

      t.timestamps
    end
    add_index :profiles, :username, unique: true
  end
end
