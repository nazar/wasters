class ItemHasSchematicColumn < ActiveRecord::Migration

  def self.up
    add_column :items, :has_schematic, :boolean, {:default => false}
    #iterate through all items and update flag for items that have schematic
    Item.transaction do
      Item.all.each do |item|
        item.has_schematic = item.full_schematics_hash[:assembley].blank? ? false : true
        item.save if item.has_schematic
      end
    end
  end

  def self.down
    remove_column :items, :has_schematic
  end

end
