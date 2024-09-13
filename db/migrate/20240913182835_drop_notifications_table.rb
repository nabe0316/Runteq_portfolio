class DropNotificationsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :notifications if table_exists?(:notifications)
  end

  def down
    create_table :notifications do |t|
      t.timestamps
    end
  end
end
