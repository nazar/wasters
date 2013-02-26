class ItemSchematic < ActiveRecord::Base

  belongs_to :item
  belongs_to :root_item, :class_name => 'Item', :foreign_key => 'root_item_id'

  #scopes

  named_scope :by_assemblies, lambda{|asmb|
    {:conditions => { :assembley => asmb.split(',').collect{|a| a.split(':').first.to_i},
                      :root_item_id => asmb.split(',').collect{|a| a.split(':').last.to_i} } }
    }

  #class methods

  #creates new ItemSchemtic and returns max assemlbey + 1
  def self.new_assembley_or_item_assembley(item_id)
    ItemSchematic.new( :assembley => Item.item_base_assembley_id(item_id) || ItemSchematic.maximum('assembley').to_i + 1 )
  end

  def self.next_assembley_id
    ItemSchematic.maximum('assembley').to_i + 1
  end

  def self.save_item_schematics(root_item, schematic_id, schematic_hash)
    schematic = ItemSchematic.find_by_id(schematic_id) || ItemSchematic.new
    schematic_item = Item.find(schematic_hash[:item_id])
    if (schematic.assembley = schematic_item.assembly_from_assemblies).nil? #Item has no assembley
      schematic.assembley = ItemSchematic.next_assembley_id
      schematic_item.assemblies = "#{schematic.assembley}:#{root_item.id}"
      schematic_item.save
    end
    schematic.root_item_id = root_item.id
    schematic.attributes = schematic_hash #item_id and qty from hash gets assigned here
    #callbacks if any
    yield(schematic) if block_given?
    #saves it
    schematic.save
    schematic #return it
  end

  def self.check_and_delete(schematic_id, qty)
    if (schematic_id.to_i > 0) && (qty.to_f == 0)
      ItemSchematic.destroy(schematic_id)
    end
  end

  #instance methods


end
