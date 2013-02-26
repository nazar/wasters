class QuestsController < ApplicationBaseController

  helper :quests
  before_filter :login_required, :except => [:index, :filter, :show, :by_sector, :by_faction]
  before_filter :admin_or_moderator_required, :only => [:destroy]

#  if AppConfig.allow_anonymous_commenting
#    skip_before_filter :verify_authenticity_token, :only => [:create]
#    skip_before_filter :login_required, :only => [:create]
#  end

  uses_tiny_mce(:only => [:new, :edit, :create, :update, :show]) do
    AppConfig.simple_mce_options
  end

  def index
    @page_title = :quest_db.l
    @quests = Quest.ascend_by_title.paginate :all, :page => params[:page]
  end

  def filter
    letter = params[:letter]
    @page_title = "#{:quest_db.l} - Filtered by #{letter}"
    @quests = Quest.letter_filter(letter).ascend_by_title.paginate :page => params[:page]
    #
    render :action => :index
  end

  def new
    @quest = Quest.new
    @quest_items = @quest.quest_items
    @previous_data = @quest.all_quests_not_this.ascend_by_title
  end

  def create
    cleanup_params
    @quest = Quest.new(params[:quest])
    @quest.user_id = current_user.id
    Quest.transaction do
      if save_and_revise_quest(@quest)
        redirect_to quests_path
      else
        new_quest_items_from_params
        render :action => :new
      end
    end  
  end

  def edit
    @quest = Quest.find(params[:id])
    @quest_items = @quest.quest_items
    @previous_data = @quest.all_quests_not_this
  end

  def update
    cleanup_params
    @quest = Quest.find(params[:id])
    @quest.attributes = params[:quest]
    @quest.updated_by = current_user.id
    Quest.transaction do
      if save_and_revise_quest(@quest)
        redirect_to quest_path(@quest)
      else
        new_quest_items_from_params
        render :action => :new
      end
    end
  end

  def destroy
    #TODO
  end

  def show
   @quest = Quest.find(params[:id])
   @quest.hit!
   @quest_chain = @quest.quest_chain
   @handins = @quest.items_handin :include => :item
   @rewards = @quest.items_reward :include => :item
  end

  def lookup
    @quest = Quest.find(params[:quest]) if params[:quest].to_i > 0
    @quest_groups = QuestGroup.for_xml
  end

  def filter_lookup #TODO remove?
    @add = params[:pos].to_i > 0 ? {'add' => true} : {}
    if params[:mask] && (params[:mask].length > 2)
      @quests = Quest.like_name(params[:mask]).ascend_by_title
    else
      @quests = []
    end
  end

  def get_items
    quest_item = QuestItem.new(:link_type => QuestItem::LinkTypeReward, :qty => 1)
    quest_item.id = rand(10000) * -1
    respond_to do |format|
      format.html {render :text => 'Javascript required'}
      format.js   {render :partial => 'quest_items/quest_item_row', :locals => {:quest_item => quest_item}}
    end
  end

  def by_sector
    @sector = params[:sector].to_i
    @quests = Quest.ascend_by_title.by_sector(@sector).paginate :all, :page => params[:page]
    #TODO @page_title
  end

  def by_faction
    @faction = params[:faction].to_i
    @quests = Quest.ascend_by_title.by_faction(@faction).paginate :all, :page => params[:page]
    #TODO @page_title
  end

  protected

  def save_and_revise_quest(quest)
    def save_quest_relations(quest, set_quest_group)
      quest.set_previous_quest(params[:previous_quest].to_i) if set_quest_group
      quest.save_items(params[:quest_items])
      quest.save
    end
    ############################################
    set_quest_group = params[:previous_quest_new_value] == 'false'
    revise = (not admin_or_moderator?)
    valid = quest.valid?
    return valid if not valid #bail if invalid data
    #continue if valid
    if admin_or_moderator?
      quest.approved_by = current_user.id
      quest.approved_at = Time.now
    end
    if revise
      quest.changeset do
        save_quest_relations(quest, set_quest_group)
      end
    else
      quest.without_revisions do
        quest.changeset do
          save_quest_relations(quest, set_quest_group)
        end
      end
    end
    valid
  end

  def new_quest_items_from_params
    def post_hash_to_quest_items(in_params)
      QuestItem.params_to_quest_items_type(in_params, 0, true).inject([]) do |objs, quest_item_hash|
        mob_item = QuestItem.new(quest_item_hash)
        mob_item.id = quest_item_hash[:id]
        objs << mob_item
      end
    end
    ###############################
    @previous_data = @quest.all_quests_not_this
    @quest_items = post_hash_to_quest_items(params[:quest_items])
  end

  def cleanup_params
    if params[:quest].delete(:quest_giver_id_new_value) == 'true'
      params[:quest].delete(:quest_giver_id)
    end
  end


end
