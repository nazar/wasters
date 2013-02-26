class Skilll < ActiveRecord::Base

  has_many :item_skill
  has_many :item, :through => :item_skill

  SkillTypeRequirement = 1
  SkillTypeModifier = 2

  #scopes

  named_scope :ids_names, :select => 'id, title'
#  named_scope :requirements, :conditions => ['skill_type = ?', Skilll::SkillTypeRequirement]
#  named_scope :modifiers, :conditions => ['skill_type = ?', Skilll::SkillTypeModifier]


end
