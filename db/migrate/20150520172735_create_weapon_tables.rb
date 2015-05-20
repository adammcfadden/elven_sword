class CreateWeaponTables < ActiveRecord::Migration
  def change
    create_table :weapons do |t|
      t.column :name, :string
      t.column :type, :string
      t.column :max_power, :int
      t.column :min_power, :int
      t.column :isequipped?, :boolean
    end

    create_table :entities_weapons, id: false do |t|
      t.integer :entity_id
      t.integer :weapon_id
    end

    add_index :entities_weapons, :entity_id
    add_index :entities_weapons, :weapon_id

  end
end
