class ItemStatWeapon < ActiveRecord::Base

  belongs_to :item
  belongs_to :ammo_item, :class_name => 'Item', :foreign_key => 'ammo_item_id'

  #consts

  ItemStatSlotBack = 1
  ItemStatSlotBelt = 2
  ItemStatSlotLegs = 3

  WeaponTypeMelee  = 1
  WeaponTypePistol = 2
  WeaponTypeRifle  = 3
  WeaponTypeThrown = 4

  WeaponSubOneHand       = 1
  WeaponSubTwoHand       = 2
  WeaponSubHandgun       = 3
  WeaponSubPistolShotgun = 4
  WeaponSubSubGun        = 5
  WeaponSubZipGun        = 6
  WeaponSubCrossbow      = 7
  WeaponSubRifle         = 8
  WeaponSubRifleShotgun  = 9
  WeaponSubSlugThrower   = 10

  DamageTypeBallistic = 1
  DamageTypeCrush     = 2
  DamageTypePierce    = 3
  DamageTypeRadiation = 4
  DamageTypeSlash     = 5

  #class methods

  def self.slots
    {ItemStatWeapon::ItemStatSlotBack => 'back', ItemStatWeapon::ItemStatSlotBelt => 'belt', ItemStatWeapon::ItemStatSlotLegs => 'legs'}
  end

  def self.weapon_types
    {ItemStatWeapon::WeaponTypeMelee => 'melee', ItemStatWeapon::WeaponTypePistol => 'pistol',
     ItemStatWeapon::WeaponTypeRifle => 'rifle', ItemStatWeapon::WeaponTypeThrown => 'thrown'}
  end

  def self.weapon_sub_types
    {ItemStatWeapon::WeaponSubOneHand =>'one handed', ItemStatWeapon::WeaponSubTwoHand => 'two handed',
     ItemStatWeapon::WeaponSubHandgun => 'handgun', ItemStatWeapon::WeaponSubPistolShotgun => 'shotgun',
     ItemStatWeapon::WeaponSubSubGun => 'sub mgun', ItemStatWeapon::WeaponSubZipGun => 'zip gun',
     ItemStatWeapon::WeaponSubCrossbow => 'crossbow', ItemStatWeapon::WeaponSubRifle => 'rifle',
     ItemStatWeapon::WeaponSubRifleShotgun => 'shotgun', ItemStatWeapon::WeaponSubSlugThrower => 'slug thrower'}
  end

  def self.damage_types
    {ItemStatWeapon::DamageTypeBallistic => 'ballistic', ItemStatWeapon::DamageTypeCrush => 'crushing',
     ItemStatWeapon::DamageTypePierce => 'piercing', ItemStatWeapon::DamageTypeRadiation => 'radiation',
     ItemStatWeapon::DamageTypeSlash => 'slash'}
  end


  #given a damages hash {damage_type_id => damage} produces a sorted damages string.
  #:verbose - produces verbose output
  def self.damages_hash_to_s(damages_hash, options={})
    verbose = options[:versbose]
    #
    sorted = damages_hash.inject({}) do |damages_by_desc, damage|
      if (damage.first.to_i > 0) && (damage.last.to_i > 0)
        damages_by_desc.merge(ItemStatWeapon.damage_types[damage.first.to_i] => damage.last.to_i)
      else
        damages_by_desc.merge({})
      end
    end.sort
    total = 0
    broken_down = sorted.inject([]) do |result, damage|
      total += damage.last.to_i
      result << (verbose ? "#{damage.last} #{damage.first.humanize}" : "#{damage.last}#{damage.first[0,1].humanize}" )
    end.join(',')
    "#{total} <em>(#{broken_down})</em>"
  end

  def self.sub_types_by_weapon_type(type)
    case type
      when ItemStatWeapon::WeaponTypeMelee
        [ItemStatWeapon::WeaponSubOneHand, ItemStatWeapon::WeaponSubTwoHand]
      when ItemStatWeapon::WeaponTypePistol
        [ItemStatWeapon::WeaponSubHandgun, ItemStatWeapon::WeaponSubPistolShotgun,
         ItemStatWeapon::WeaponSubSubGun, ItemStatWeapon::WeaponSubZipGun]
      when ItemStatWeapon::WeaponTypeRifle
        [ItemStatWeapon::WeaponSubCrossbow, ItemStatWeapon::WeaponSubRifle,
         ItemStatWeapon::WeaponSubRifleShotgun,  ItemStatWeapon::WeaponSubSlugThrower]
      else
        []
    end
  end

  #instance methods

  def slot_to_s
    ItemStatWeapon.slots[slot] || ''
  end

  def weapon_type_to_s
    ItemStatWeapon.weapon_types[weapon_type]  || ''
  end

  def sub_type_to_s
    ItemStatWeapon.weapon_sub_types[weapon_subtype]  || ''
  end

  def damages_to_s
    damages_hash = damage.split(',').inject({}){|out, damage| out.merge(damage.split(':').first => damage.split(':').last)}
    ItemStatWeapon.damages_hash_to_s(damages_hash)
  end

  def ammo_item_name
    ammo_item.title unless ammo_item.blank?
  end


end
