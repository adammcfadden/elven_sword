class AddAliveColumnToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :alive?, :boolean
  end
end
