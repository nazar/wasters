class WeaponReloadRename < ActiveRecord::Migration

  def self.up
    rename_column :item_stat_weapons, :reload, :reload_stat
  end

  def self.down
    rename_column :item_stat_weapons, :reload_stat, :reload
  end

end
