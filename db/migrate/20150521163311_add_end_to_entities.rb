class AddEndToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :vit, :int
  end
end
