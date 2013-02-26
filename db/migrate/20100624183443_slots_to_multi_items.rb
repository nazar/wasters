class SlotsToMultiItems < ActiveRecord::Migration

  def self.up
    change_column :item_stat_armours, :slot, :string, {:limit => 100}
    #we have item slots 10 to 15.. these need to be converted to A-F
    ItemStatArmour.all.each do |item|
      unless item.slot.blank?
        item.slot = 'A' if item.slot.to_i == 10
        item.slot = 'B' if item.slot.to_i == 11
        item.slot = 'C' if item.slot.to_i == 12
        item.slot = 'D' if item.slot.to_i == 13
        item.slot = 'E' if item.slot.to_i == 14
        item.slot = 'F' if item.slot.to_i == 15
        item.save
      end
    end
  end

  def self.down
    #this is slightly trickier.. need temp column then take first item and save it in temp
    add_column :item_stat_armours, :tmp, :integer
    ItemStatArmour.all.each do |item|
      unless item.split(',').first.blank?
        item.tmp = 10 if item.split(',').first == 'A'
        item.tmp = 11 if item.split(',').first == 'B'
        item.tmp = 12 if item.split(',').first == 'C'
        item.tmp = 13 if item.split(',').first == 'D'
        item.tmp = 14 if item.split(',').first == 'E'
        item.tmp = 15 if item.split(',').first == 'F'
        item.save
      end
    end
    change_column :item_stat_armours, :slot, :integer
    #
    ItemStatArmour.update_all('slot = tmp')
    #
    remove_column :item_stat_armours, :tmp
  end

end
