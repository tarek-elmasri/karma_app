class AddSalesToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :sales, :float, default: 0
  end
end
