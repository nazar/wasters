#direct override of CE base_controller
class BaseController

  helper :activities

  def footer_app_content
    get_app_recent_footer_content
    render :partial => 'shared/footer_content'
  end

  protected

  def get_app_recent_footer_content
    #get general activity
    #TODO seem to be redundant or theme specific... keep for further investigation
#    @recent_clippings = Clipping.find_recent(:limit => 10)
#    @recent_photos = Photo.find_recent(:limit => 10)
#    @recent_comments = Comment.find_recent(:limit => 13)
    #override for quests and items to only display specific activity
    if params[:id] == 'quests'
      @recent_activity = Quest.recent_quest_activity(:include => [:item, :user], :limit => 15)
      @popular_tags = popular_tags(30, ' count DESC', 'Quest')
    elsif params[:id] == 'items'
      @recent_activity = Item.recent_item_activity(:include => [:item, :user], :limit => 15)
      @popular_tags = popular_tags(30, ' count DESC', 'Item')
    elsif params[:id] == 'mobs'
      @recent_activity = Mob.recent_item_activity(:include => [:item, :user], :limit => 15)
      @popular_tags = popular_tags(30, ' count DESC', 'Mob')
    else
      @recent_activity = User.fe_recent_activity(:limit => 15, :include => [:item, :user])
      @popular_tags = popular_tags(30, ' count DESC')
    end
  end
  
  
end