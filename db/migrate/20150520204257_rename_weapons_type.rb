class RenameWeaponsType < ActiveRecord::Migration
  def change
    rename_column :weapons, :type, :category
  end
end
