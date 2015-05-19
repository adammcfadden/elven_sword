class AddXpColumnToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :xp, :int
  end
end
