class MobExtraFields < ActiveRecord::Migration

  def self.up
    add_column :mobs, :coords_x, :float
    add_column :mobs, :coords_y, :float
  end

  def self.down
    remove_column :mobs, :coords_x
    remove_column :mobs, :coords_y
  end
  
end
