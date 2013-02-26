module QuestGroupHelper

  def quest_group_select
    select :quest, :quest_group_id, QuestGroup.ascend_by_name
  end

end