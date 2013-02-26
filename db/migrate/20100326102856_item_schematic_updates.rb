class ItemSchematicUpdates < ActiveRecord::Migration

  def self.up
    remove_column :items, :level
    add_column :items, :assemblies, :string, {:limit => 255}
  end

  def self.down
    add_column :items, :level, :integer
    remove_column :items, :assemblies
  end

end
