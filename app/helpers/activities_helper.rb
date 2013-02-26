module ActivitiesHelper

  def activity_to_verb(activity)
    case activity.item_type
      when 'Item'
        action = activity.action == 'item' ? 'Added' : activity.action.humanize
      when 'Quest'
        action = activity.action == 'quest' ? 'Added' : activity.action.humanize
      when 'Mob'
        action = activity.action == 'mob' ? 'Added' : activity.action.humanize
    end
    action
  end

end
