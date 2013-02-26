class CreateItemStatArmours < ActiveRecord::Migration

  def self.up
    create_table :item_stat_armours do |t|
      t.integer :item_id, :slot
      t.integer :slashing, :piercing, :crushing, :ballistic, :fire, :cold, :acid, :radiation, :poison,
                :sonic, :electric, :psionic, :disease
      t.timestamps
    end
    add_index :item_stat_armours, :item_id, {:name => 'item_stat_armour_item'}
  end

  def self.down
    drop_table :item_stat_armours
  end

end
