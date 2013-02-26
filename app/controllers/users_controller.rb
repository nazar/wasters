class UsersController  < BaseController

  def show
    @friend_count               = @user.accepted_friendships.count
    @accepted_friendships       = @user.accepted_friendships.find(:all, :limit => 5).collect{|f| f.friend }
    @pending_friendships_count  = @user.pending_friendships.count()

    @comments       = @user.comments.find(:all, :limit => 10, :order => 'created_at DESC')
    @photo_comments = Comment.find_photo_comments_for(@user)
    @users_comments = Comment.find_comments_by_user(@user, :limit => 5)

    @recent_posts   = @user.posts.find(:all, :limit => 2, :order => "published_at DESC")
    @clippings      = @user.clippings.find(:all, :limit => 5)
    @photos         = @user.photos.find(:all, :limit => 5)
    @comment        = Comment.new(params[:comment])

    @recent_items   = @user.items.recent.all :limit => 5
    @recent_mobs    = @user.mobs.recent.all :limit => 5
    @recent_quests  = @user.quests.recent.all :limit => 5

    @my_activity = Activity.recent.by_users([@user.id]).find(:all, :limit => 10)

    update_view_count(@user) unless current_user && current_user.eql?(@user)
  end

end