class MobsController < ApplicationBaseController

  include ItemMixinHelpers

  before_filter :login_required, :except => [:index, :filter, :show, :by_categories, :by_difficulty]
  before_filter :admin_or_moderator_required, :only => [:destroy]

#  if AppConfig.allow_anonymous_commenting
#    skip_before_filter :verify_authenticity_token, :only => [:create]
#    skip_before_filter :login_required, :only => [:create]
#  end

  uses_tiny_mce(:only => [:new, :edit, :create, :update, :show]) do
    AppConfig.simple_mce_options
  end


  def index
    @page_title = :mob_db.l
    @mobs = Mob.ascend_by_name.paginate :page => params[:page]
    @page_title = :viewing_all_mobs.l
  end

  def filter
    letter = params[:letter]
    @page_title = "#{:mob_db.l} - Filtered by #{letter}"
    @mobs = Mob.letter_filter(letter).ascend_by_name.paginate :page => params[:page]
    #
    render :action => :index
  end

  def new
    @mob = Mob.new(:mob_type => Mob::MobTypeMob)
    init_mob_associations
  end

  def create
    @mob = Mob.new(params[:mob])
    @mob.user_id = current_user.id
    Mob.transaction do
      if save_and_revise_mob(@mob)
        redirect_to mobs_path
      else
        new_mob_items_from_params
        render :action => :new
      end
    end
  end

  def edit
    @mob = Mob.find(params[:id])
    init_mob_associations
  end

  def update
    @mob = Mob.find(params[:id])
    @mob.attributes = params[:mob]
    @mob.updated_by = current_user.id
    Mob.transaction do
      if save_and_revise_mob(@mob)
        redirect_to mob_path(@mob)
      else
        new_mob_items_from_params
        render :action => :edit
      end
    end
  end

  def show
    @mob = Mob.find(params[:id])
    @quests_given = @mob.quests_given.ascend_by_title :include => :quests
    if @mob.mob_type == Mob::MobTypeMob
      @drops = @mob.items_drop
      @skins = @mob.items_skin
    elsif @mob.mob_type == Mob::MobTypeMerchant
      @mob_items = @mob.items_sell
    else
      @mob_items = @mob.mob_item_items
    end
    @mob.hit!
    @page_title = "#{@mob.name} - Fallen Earth Mob Database"
  end

  def destroy
    #TODO
  end

  #called by mob_type combo to get mob_type sub form
  def properties
    @mob = Mob.new(:mob_type => params[:select_id].to_i)
    init_mob_associations
    #
    respond_to do |format|
      format.html {render :text => 'Javascript support required'}
      format.js   {render :partial => 'mobs/mob_properties'}
    end
  end

  #called by add item link when adding mob drops, merchant sells and so on
  def items
    @mob_item = MobItem.new(:quantity => 1)
    @mob_item.id = rand(10000) * -1
    respond_to do |format|
      format.html {render :text => 'Javascript support required'}
      format.js   {render :partial => 'mobs/edit_verb', :locals => {:mob_item => @mob_item, :verb => params[:verb]} }
    end
  end

  def by_categories
    @cat = params[:cat].to_i
    @mobs =  Mob.ascend_by_name.by_mob_type(@cat).paginate :page => params[:page]
    #TODO @page_title
  end

  def by_difficulty
    @diff = params[:diff].to_i
    @mobs = Mob.ascend_by_name.by_difficulty(@diff).paginate :page => params[:page]
    #TODO @page_title
  end

  def get_for_xml
    if params[:type].to_i == Mob::MobQuestorsType.to_i
      @mobs = Mob.quest_givers.ascend_by_name
    else
      @mobs = Mob.ascend_by_name
    end
    #
    respond_to do |format|
      format.xml {}
    end
  end

  protected

  def init_mob_associations
    if @mob.mob_type == Mob::MobTypeMob
      @drops = @mob.mob_items.drops.item_ordered
      @skins = @mob.mob_items.skins.item_ordered
    elsif @mob.mob_type == Mob::MobTypeMerchant 
      @mob_items = @mob.mob_items.sells.item_ordered
    elsif @mob.mob_type == Mob::MobTypeNode
      @mob_items = @mob.mob_items.harvests.item_ordered
    elsif @mob.mob_type == Mob::MobTypeMine
      @mob_items = @mob.mob_items.mines.item_ordered
    end
  end

  def new_mob_items_from_params
    def post_hash_to_mob_items(in_params)
      MobItem.params_to_mob_items_type(in_params, 0, true).inject([]) do |objs, mob_item_hash|
        mob_item = MobItem.new(mob_item_hash)
        mob_item.id = mob_item_hash[:id]
        objs << mob_item
      end
    end
    ###############################
    if @mob.mob_type == Mob::MobTypeMob
      @drops = post_hash_to_mob_items(params[:drop])
      @skins = post_hash_to_mob_items(params[:skin])
    else
      unless params[:sell].blank? && params[:node].blank? && params[:mine].blank?
        @mob_items = post_hash_to_mob_items( params[:sell] ||
                                             params[:node] ||
                                             params[:mine] ) 
      else
        []
      end  
    end
  end

  def save_and_revise_mob(mob)
    def save_mob_relations(mob)
      mob_items = MobItem.params_hash_to_array(params)
      mob.quick_coords_to_xy_coords(params[:quick_coords])
      mob.mob_items_attributes = mob_items
      mob.save
    end
    ############################################
    revise = (not admin_or_moderator?)
    valid = mob.valid?
    return valid unless valid #bail if invalid data
    #continue if valid
    if admin_or_moderator?
      mob.approved_by = current_user.id
      mob.approved_at = Time.now
    end
    if revise
      mob.changeset do
        save_mob_relations(mob)
      end
    else
      mob.without_revisions do
        mob.changeset do
          save_mob_relations(mob)
        end
      end
    end
    valid
  end



end
