class AddTitleToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :title, :string
  end
end
