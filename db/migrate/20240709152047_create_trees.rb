class CreateTrees < ActiveRecord::Migration[7.0]
  def change
    create_table :trees do |t|
      t.references :user, null: false, foreign_key: true
      t.text :svg_date

      t.timestamps
    end
  end
end
