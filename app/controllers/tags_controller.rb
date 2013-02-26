class TagsController < BaseController

  def show
    tag_names = URI::decode(params[:id])

    @tags = Tag.find(:all, :conditions => [ 'name IN (?)', TagList.from(tag_names) ] )
    if @tags.nil? || @tags.empty?
      flash[:notice] = :tag_does_not_exists.l_with_args(:tag => tag_names)
      redirect_to :action => :index and return
    end
    @related_tags = @tags.collect { |tag| tag.related_tags }.flatten.uniq
    @tags_raw = @tags.collect { |t| t.name } .join(',')

    if params[:type]
      case params[:type]
        when 'Post', 'posts'
          @pages = @posts = Post.recent.find_tagged_with(tag_names, :match_all => true, :page => {:size => 20, :current => params[:page]})
          @photos, @users, @clippings = [], [], []
        when 'Photo', 'photos'
          @pages = @photos = Photo.recent.find_tagged_with(tag_names, :match_all => true, :page => {:size => 30, :current => params[:page]})
          @posts, @users, @clippings = [], [], []
        when 'User', 'users'
          @pages = @users = User.recent.find_tagged_with(tag_names, :match_all => true, :page => {:size => 30, :current => params[:page]})
          @posts, @photos, @clippings = [], [], []
        when 'Clipping', 'clippings'
          @pages = @clippings = Clipping.recent.find_tagged_with(tag_names, :match_all => true, :page => {:size => 10, :current => params[:page]})
          @posts, @photos, @users = [], [], []
        when 'Mob', 'mobs'
          @mobs = Mob.recent.find_tagged_with(tag_names, :match_all => true, :page => {:size => 30, :current => params[:page]})
          @clippings, @posts, @photos, @users = [], [], [], []
        when 'Quest', 'quests'
          @quests = Quest.recent.find_tagged_with(tag_names, :match_all => true, :page => {:size => 30, :current => params[:page]})
          @clippings, @posts, @photos, @users = [], [], [], []
        when 'Item', 'items'
          @items = Item.recent.find_tagged_with(tag_names, :match_all => true, :page => {:size => 30, :current => params[:page]})
          @clippings, @posts, @photos, @users = [], [], [], []
      else
        @clippings, @posts, @photos, @users = [], [], [], []
      end
    else
      @posts = Post.recent.find_tagged_with(tag_names, :match_all => true, :limit => 5)
      @photos = Photo.recent.find_tagged_with(tag_names, :match_all => true, :limit => 10)
      @users = User.recent.find_tagged_with(tag_names, :match_all => true, :limit => 10).uniq
      @clippings = Clipping.recent.find_tagged_with(tag_names, :match_all => true, :limit => 10)
      @quests = Quest.recent.find_tagged_with(tag_names, :match_all => true, :limit => 10)
      @items = Item.recent.find_tagged_with(tag_names, :match_all => true, :limit => 10)
      @mobs = Mob.recent.find_tagged_with(tag_names, :match_all => true, :limit => 10)
    end
  end

end