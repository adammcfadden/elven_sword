class InitializeDatabase < ActiveRecord::Migration
  def change
      create_table :entities do |t|
        t.column :name, :string
        t.column :level, :int
        t.column :health, :int
        t.column :location_x, :int
        t.column :location_y, :int
        t.column :pc?, :boolean
    end
  end
end
