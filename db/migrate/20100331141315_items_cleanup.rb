class ItemsCleanup < ActiveRecord::Migration

  def self.up
    drop_table :items_links
  end

  def self.down
  end

end
