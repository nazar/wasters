class ItemStatArmour < ActiveRecord::Base

  belongs_to :item

  #consts

  ItemStatSlotArms      = '1'
  ItemStatSlotBack      = '2'
  ItemStatSlotChest     = '3'
  ItemStatSlotEars      = '4'
  ItemStatSlotEyes      = '5'
  ItemStatSlotFeet      = '6'
  ItemStatSlotGroin     = '7'
  ItemStatSlotHands     = '8'
  ItemStatSlotHead      = '9'
  ItemStatSlotMouth     = 'A'
  ItemStatSlotShoulders = 'B'
  ItemStatSlotStorage   = 'C'
  ItemStatSlotThighs    = 'D'
  ItemStatSlotWaist     = 'E'
  ItemStatSlotWrist     = 'F'


  #class methods

  def self.slots
    {ItemStatArmour::ItemStatSlotArms => 'arms', ItemStatArmour::ItemStatSlotBack => 'back', ItemStatArmour::ItemStatSlotChest => 'chest',
     ItemStatArmour::ItemStatSlotEars => 'ears', ItemStatArmour::ItemStatSlotEyes => 'eyes', ItemStatArmour::ItemStatSlotFeet => 'feet',
     ItemStatArmour::ItemStatSlotGroin => 'groin', ItemStatArmour::ItemStatSlotHands => 'hands', ItemStatArmour::ItemStatSlotHead => 'head',
     ItemStatArmour::ItemStatSlotMouth => 'mouth', ItemStatArmour::ItemStatSlotShoulders => 'shoulders', ItemStatArmour::ItemStatSlotStorage => 'storage',
     ItemStatArmour::ItemStatSlotThighs => 'thighs', ItemStatArmour::ItemStatSlotWaist => 'waist', ItemStatArmour::ItemStatSlotWrist => 'wrists'}
  end

  def self.slots_abbreviated
    {ItemStatArmour::ItemStatSlotArms => 'a', ItemStatArmour::ItemStatSlotBack => 'b', ItemStatArmour::ItemStatSlotChest => 'c',
     ItemStatArmour::ItemStatSlotEars => 'er', ItemStatArmour::ItemStatSlotEyes => 'ey', ItemStatArmour::ItemStatSlotFeet => 'f',
     ItemStatArmour::ItemStatSlotGroin => 'g', ItemStatArmour::ItemStatSlotHands => 'hn', ItemStatArmour::ItemStatSlotHead => 'hd',
     ItemStatArmour::ItemStatSlotMouth => 'm', ItemStatArmour::ItemStatSlotShoulders => 'sh', ItemStatArmour::ItemStatSlotStorage => 'st',
     ItemStatArmour::ItemStatSlotThighs => 't', ItemStatArmour::ItemStatSlotWaist => 'wa', ItemStatArmour::ItemStatSlotWrist => 'wr'}
  end

  #instance methods

  def slot_to_a
    slot.split(',').inject([]) do |out, this_slot|
      out << ItemStatArmour.slots[this_slot]
    end
  end

  def slot_to_s
    slot_to_a.join(', ')
  end

  def slot_abbreviated_to_a
    slot_sorted_by_name_to_a.inject([]) do |out, this_slot|
      out << ItemStatArmour.slots_abbreviated[this_slot]
    end
  end

  def slot_abbreviated_to_s
    slot_abbreviated_to_a.join(', ')
  end

  def slot_sorted_by_name_to_a
    slot.split(',').sort{|a,b| ItemStatArmour.slots[a] <=> ItemStatArmour.slots[b]}
  end

  def include?(slot_code)
    slot.split(',').include?(slot_code) unless slot.blank?
  end

end
