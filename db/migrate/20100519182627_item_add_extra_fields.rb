class ItemAddExtraFields < ActiveRecord::Migration

  def self.up
    add_column :items, :quest_item, :boolean, {:default => false}
    add_column :items, :non_tradable, :boolean, {:default => false}
    add_column :items, :craft_time_h, :integer
    add_column :items, :craft_time_m, :integer
    add_column :items, :craft_time_s, :integer
  end

  def self.down
    remove_column :items, :quest_item
    remove_column :items, :non_tradable
    remove_column :items, :craft_time_h
    remove_column :items, :craft_time_m
    remove_column :items, :craft_time_s
  end

end
