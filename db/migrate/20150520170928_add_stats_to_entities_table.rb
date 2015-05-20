class AddStatsToEntitiesTable < ActiveRecord::Migration
  def change
    add_column :entities, :str, :int
  end
end
