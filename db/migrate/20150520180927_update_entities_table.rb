class UpdateEntitiesTable < ActiveRecord::Migration
  def change
    add_column :entities, :image_path, :string
    add_column :entities, :entity_drawn?, :boolean
  end
end
