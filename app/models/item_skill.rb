class ItemSkill < ActiveRecord::Base

  belongs_to :item
  belongs_to :skilll

  #const

  LinkTypeDefence  = 1
  LinkTypeAttack   = 2
  LinkTypeRequired = 3
  LinkTypeMod1     = 4
  LinkTypeMod2     = 5

  named_scope :requirement, :conditions => ['link_type = ?', ItemSkill::LinkTypeRequired]
  named_scope :not_requirement, :conditions => ['link_type <> ?', ItemSkill::LinkTypeRequired]


  #class methods

  def self.link_types
    {ItemSkill::LinkTypeDefence => 'defence', LinkTypeAttack => 'attack', LinkTypeRequired => 'requirement',
     LinkTypeMod1 => 'modifier 1', LinkTypeMod2 => 'modifier 2'}      
  end

  def self.skill_no_level
    [ItemSkill::LinkTypeDefence, ItemSkill::LinkTypeAttack]
  end

  #instance methods

  def link_type_to_s
    ItemSkill.link_types[link_type]
  end



end
