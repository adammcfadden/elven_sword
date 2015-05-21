class AddBattleFlagToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :in_battle?, :boolean
  end
end
