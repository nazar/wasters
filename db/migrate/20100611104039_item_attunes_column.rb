class ItemAttunesColumn < ActiveRecord::Migration

  def self.up
    add_column :items, :attunes, :boolean, {:default => false}
  end

  def self.down
    remove_column :items, :attunes
  end

end
