class QuestGroup < ActiveRecord::Base

  has_many :quests



  named_scope :for_xml, {:select => 'id, name', :order => 'name'}


end
