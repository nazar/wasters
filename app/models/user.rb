class User < ActiveRecord::Base

  #overrides CE user model

  has_many :items
  has_many :mobs
  has_many :quests

  #class methods

  def self.fe_recent_activity( options = {})
    Activity.recent.find(:all,
      {:select => 'activities.*',
      :conditions => "users.activated_at IS NOT NULL",
      :joins => "LEFT JOIN users ON users.id = activities.user_id"}.merge(options))
  end

  def self.recent_activity_by_type(activity_class, page = {}, options = {})
    page.reverse_merge! :size => 10, :current => 1
    Activity.recent.find(:all,
      :select => 'activities.*',
      :conditions => ["users.activated_at IS NOT NULL and activities.item_type = ?", activity_class.name],
      :joins => "LEFT JOIN users ON users.id = activities.user_id",
      :page => page, *options)
  end


  #instance methods

  def admin_or_moderator?
    admin? || moderator?
  end


end