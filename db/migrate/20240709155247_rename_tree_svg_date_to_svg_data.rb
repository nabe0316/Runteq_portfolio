class RenameTreeSvgDateToSvgData < ActiveRecord::Migration[7.0]
  def change
    rename_column :trees, :svg_date, :svg_data
  end
end
