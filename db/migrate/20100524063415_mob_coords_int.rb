class MobCoordsInt < ActiveRecord::Migration

  def self.up
    change_column :mobs, :coords_x, :integer
    change_column :mobs, :coords_y, :integer
  end

  def self.down
    change_column :mobs, :coords_x, :float
    change_column :mobs, :coords_y, :float
  end

end
