class ActivitiesController

  def index
    @activities = User.fe_recent_activity(:include => [:item]).paginate :page => params[:page]
    @popular_tags = popular_tags(30, ' count DESC')    
  end
  
end
