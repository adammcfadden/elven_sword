class AddBattleTable < ActiveRecord::Migration
  def change

    create_table :battles do |t|
      t.column :name, :string
      t.column :boss?, :boolean
    end

    add_column :entities, :battle_id, :int

  end
end
