class CreateItemStatWeapons < ActiveRecord::Migration

  def self.up
    create_table :item_stat_weapons do |t|
      t.integer :item_id, :ammo_item_id
      t.integer :weapon_type, :weapon_subtype, :slot, :ammo
      t.float :dps, :delay, :reload, :max_range
      t.string :damage
      t.timestamps
    end
    add_index :item_stat_weapons, :item_id, {:name => 'item_stat_weapons_item'}
    add_index :item_stat_weapons, :ammo_item_id, {:name => 'item_stat_weapons_ammo'}
  end

  def self.down
    drop_table :item_stat_weapons
  end
  
end
