# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100701193645) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "action",     :limit => 50
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
  end

  add_index "activities", ["created_at"], :name => "index_activities_on_created_at"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "ads", :force => true do |t|
    t.string   "name"
    t.text     "html"
    t.integer  "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location"
    t.boolean  "published",        :default => false
    t.boolean  "time_constrained", :default => false
    t.string   "audience",         :default => "all"
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count"
  end

  create_table "assets", :force => true do |t|
    t.string   "filename"
    t.integer  "width"
    t.integer  "height"
    t.string   "content_type"
    t.integer  "size"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "thumbnail"
    t.integer  "parent_id"
  end

  create_table "categories", :force => true do |t|
    t.string "name"
    t.text   "tips"
    t.string "new_post_text"
    t.string "nav_text"
  end

  create_table "choices", :force => true do |t|
    t.integer "poll_id"
    t.string  "description"
    t.integer "votes_count", :default => 0
  end

  create_table "clippings", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.string   "image_url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "favorited_count", :default => 0
  end

  add_index "clippings", ["created_at"], :name => "index_clippings_on_created_at"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.datetime "created_at",                                       :null => false
    t.integer  "commentable_id",                 :default => 0,    :null => false
    t.string   "commentable_type", :limit => 15, :default => "",   :null => false
    t.integer  "user_id",                        :default => 0,    :null => false
    t.integer  "recipient_id"
    t.text     "comment"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
    t.boolean  "notify_by_email",                :default => true
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["recipient_id"], :name => "index_comments_on_recipient_id"
  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "contests", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.text     "raw_post"
    t.text     "post"
    t.string   "banner_title"
    t.string   "banner_subtitle"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "description"
    t.integer  "metro_area_id"
    t.string   "location"
    t.boolean  "allow_rsvp",    :default => true
  end

  create_table "favorites", :force => true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "favoritable_type"
    t.integer  "favoritable_id"
    t.integer  "user_id"
    t.string   "ip_address",       :default => ""
  end

  add_index "favorites", ["user_id"], :name => "fk_favorites_user"

  create_table "forums", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "topics_count",     :default => 0
    t.integer "sb_posts_count",   :default => 0
    t.integer "position"
    t.text    "description_html"
    t.string  "owner_type"
    t.integer "owner_id"
  end

  create_table "friendship_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "friend_id"
    t.integer  "user_id"
    t.boolean  "initiator",            :default => false
    t.datetime "created_at"
    t.integer  "friendship_status_id"
  end

  add_index "friendships", ["friendship_status_id"], :name => "index_friendships_on_friendship_status_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "homepage_features", :force => true do |t|
    t.datetime "created_at"
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "updated_at"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "invitations", :force => true do |t|
    t.string   "email_addresses"
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "item_links", :force => true do |t|
    t.integer  "item_id"
    t.integer  "link_id"
    t.integer  "item_link_type"
    t.string   "link_type",      :limit => 50
    t.float    "qty",                          :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_links", ["item_id"], :name => "index_item_links_on_item_id"
  add_index "item_links", ["link_id"], :name => "index_item_links_on_link_id"

  create_table "item_schematics", :force => true do |t|
    t.integer  "assembley"
    t.integer  "root_item_id"
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "updated_by"
    t.integer  "level",        :default => 0
    t.float    "qty",          :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_schematics", ["assembley"], :name => "index_item_schematics_on_assembley"
  add_index "item_schematics", ["item_id"], :name => "index_item_schematics_on_item_id"
  add_index "item_schematics", ["root_item_id"], :name => "index_item_schematics_on_root_item_id"
  add_index "item_schematics", ["updated_by"], :name => "index_item_schematics_on_updated_by"
  add_index "item_schematics", ["user_id"], :name => "index_item_schematics_on_user_id"

  create_table "item_skills", :force => true do |t|
    t.integer  "item_id"
    t.integer  "skilll_id"
    t.integer  "level"
    t.integer  "link_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_skills", ["item_id"], :name => "index_item_skills_on_item_id"
  add_index "item_skills", ["skilll_id"], :name => "index_item_skills_on_skilll_id"

  create_table "item_stat_armours", :force => true do |t|
    t.integer  "item_id"
    t.string   "slot"
    t.integer  "slashing"
    t.integer  "piercing"
    t.integer  "crushing"
    t.integer  "ballistic"
    t.integer  "fire"
    t.integer  "cold"
    t.integer  "acid"
    t.integer  "radiation"
    t.integer  "poison"
    t.integer  "sonic"
    t.integer  "electric"
    t.integer  "psionic"
    t.integer  "disease"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_stat_armours", ["item_id"], :name => "item_stat_armour_item"

  create_table "item_stat_weapons", :force => true do |t|
    t.integer  "item_id"
    t.integer  "ammo_item_id"
    t.integer  "weapon_type"
    t.integer  "weapon_subtype"
    t.integer  "slot"
    t.integer  "ammo"
    t.float    "dps"
    t.float    "delay"
    t.float    "reload_stat"
    t.float    "max_range"
    t.string   "damage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_stat_weapons", ["ammo_item_id"], :name => "item_stat_weapons_ammo"
  add_index "item_stat_weapons", ["item_id"], :name => "item_stat_weapons_item"

  create_table "items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "updated_by"
    t.integer  "views_count",                      :default => 0
    t.integer  "comments_count",                   :default => 0
    t.integer  "category"
    t.string   "title",             :limit => 250
    t.string   "cached_tag_list",   :limit => 250
    t.float    "weight"
    t.float    "vendor_buy_price"
    t.float    "vendor_sell_price"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assemblies"
    t.integer  "sub_category"
    t.integer  "level"
    t.integer  "condition"
    t.integer  "min_condition"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.boolean  "quest_item",                       :default => false
    t.boolean  "non_tradable",                     :default => false
    t.integer  "craft_time_h"
    t.integer  "craft_time_m"
    t.integer  "craft_time_s"
    t.integer  "requirement_id"
    t.integer  "requirement_level"
    t.boolean  "not_sold"
    t.boolean  "attunes",                          :default => false
    t.boolean  "has_schematic",                    :default => false
  end

  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metro_areas", :force => true do |t|
    t.string  "name"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "users_count", :default => 0
  end

  create_table "mob_items", :force => true do |t|
    t.integer  "mob_id"
    t.integer  "item_id"
    t.integer  "mob_item_type"
    t.float    "quantity"
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number"
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current"
    t.integer  "frequency",                  :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mob_items", ["item_id"], :name => "index_mob_items_on_item_id"
  add_index "mob_items", ["mob_id"], :name => "index_mob_items_on_mob_id"
  add_index "mob_items", ["revisable_original_id"], :name => "index_mob_items_on_revisable_original_id"

  create_table "mobs", :force => true do |t|
    t.integer  "mob_type"
    t.integer  "difficulty"
    t.integer  "hp"
    t.string   "name",                       :limit => 100
    t.text     "description"
    t.integer  "user_id"
    t.integer  "updated_by"
    t.integer  "images_count",                              :default => 0
    t.integer  "markers_count",                             :default => 0
    t.integer  "comments_count",                            :default => 0
    t.integer  "items_count",                               :default => 0
    t.integer  "views_count",                               :default => 0
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number"
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current"
    t.integer  "approved_by"
    t.datetime "approved_at"
    t.string   "melee_weakness",             :limit => 150
    t.string   "spell_weakness",             :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_tag_list",            :limit => 250
    t.integer  "coords_x"
    t.integer  "coords_y"
    t.boolean  "quest_giver"
  end

  add_index "mobs", ["approved_by"], :name => "index_mobs_on_approved_by"
  add_index "mobs", ["revisable_original_id"], :name => "index_mobs_on_revisable_original_id"
  add_index "mobs", ["updated_by"], :name => "index_mobs_on_updated_by"
  add_index "mobs", ["user_id"], :name => "index_mobs_on_user_id"

  create_table "moderatorships", :force => true do |t|
    t.integer "forum_id"
    t.integer "user_id"
  end

  add_index "moderatorships", ["forum_id"], :name => "index_moderatorships_on_forum_id"

  create_table "monitorships", :force => true do |t|
    t.integer "topic_id"
    t.integer "user_id"
    t.boolean "active",   :default => true
  end

  create_table "offerings", :force => true do |t|
    t.integer "skill_id"
    t.integer "user_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "published_as", :limit => 16, :default => "draft"
    t.boolean  "page_public",                :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "album_id"
    t.integer  "view_count"
  end

  add_index "photos", ["created_at"], :name => "index_photos_on_created_at"
  add_index "photos", ["parent_id"], :name => "index_photos_on_parent_id"

  create_table "plugin_schema_migrations", :id => false, :force => true do |t|
    t.string "plugin_name"
    t.string "version"
  end

  create_table "polls", :force => true do |t|
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "votes_count", :default => 0
  end

  add_index "polls", ["created_at"], :name => "index_polls_on_created_at"
  add_index "polls", ["post_id"], :name => "index_polls_on_post_id"

  create_table "posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_post"
    t.text     "post"
    t.string   "title"
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "view_count",                    :default => 0
    t.integer  "contest_id"
    t.integer  "emailed_count",                 :default => 0
    t.integer  "favorited_count",               :default => 0
    t.string   "published_as",    :limit => 16, :default => "draft"
    t.datetime "published_at"
    t.integer  "comments_count",                :default => 0
  end

  add_index "posts", ["category_id"], :name => "index_posts_on_category_id"
  add_index "posts", ["published_as"], :name => "index_posts_on_published_as"
  add_index "posts", ["published_at"], :name => "index_posts_on_published_at"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "quest_groups", :force => true do |t|
    t.string   "name",       :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quest_groups", ["name"], :name => "index_quest_groups_on_name"

  create_table "quest_items", :force => true do |t|
    t.integer  "item_id"
    t.integer  "quest_id"
    t.integer  "link_type"
    t.float    "qty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number"
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current"
  end

  add_index "quest_items", ["item_id"], :name => "index_quest_items_on_item_id"
  add_index "quest_items", ["quest_id"], :name => "index_quest_items_on_quest_id"
  add_index "quest_items", ["revisable_original_id"], :name => "index_quest_items_on_revisable_original_id"

  create_table "quests", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "comments_count",             :default => 0
    t.integer  "items_count",                :default => 0
    t.integer  "views_count",                :default => 0
    t.integer  "rating",                     :default => 0
    t.integer  "level"
    t.integer  "sector"
    t.integer  "user_id"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number"
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current"
    t.integer  "quest_group_id"
    t.integer  "position"
    t.string   "cached_tag_list"
    t.integer  "approved_by"
    t.datetime "approved_at"
    t.text     "objective"
    t.integer  "ap"
    t.integer  "chips"
    t.integer  "experience"
    t.integer  "faction"
    t.integer  "faction_type"
    t.integer  "quest_giver_id"
  end

  add_index "quests", ["quest_giver_id"], :name => "index_quests_on_quest_giver_id"
  add_index "quests", ["quest_group_id"], :name => "index_quests_on_quest_group_id"
  add_index "quests", ["title"], :name => "index_quests_on_title"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "rsvps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "attendees_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sb_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.text     "body_html"
  end

  add_index "sb_posts", ["forum_id", "created_at"], :name => "index_sb_posts_on_forum_id"
  add_index "sb_posts", ["user_id", "created_at"], :name => "index_sb_posts_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "sessid"
    t.text     "data"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "sessions", ["sessid"], :name => "index_sessions_on_sessid"

  create_table "skillls", :force => true do |t|
    t.string   "title",       :limit => 250
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "skill_type",                 :default => 0
  end

  create_table "skills", :force => true do |t|
    t.string "name"
  end

  create_table "states", :force => true do |t|
    t.string "name"
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string  "taggable_type"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id"
  add_index "taggings", ["taggable_type"], :name => "index_taggings_on_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",           :default => 0
    t.integer  "sticky",         :default => 0
    t.integer  "sb_posts_count", :default => 0
    t.datetime "replied_at"
    t.boolean  "locked",         :default => false
    t.integer  "replied_by"
    t.integer  "last_post_id"
  end

  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"
  add_index "topics", ["forum_id", "sticky", "replied_at"], :name => "index_topics_on_sticky_and_replied_at"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.text     "description"
    t.integer  "avatar_id"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.text     "stylesheet"
    t.integer  "view_count",                           :default => 0
    t.boolean  "vendor",                               :default => false
    t.string   "activation_code",        :limit => 40
    t.datetime "activated_at"
    t.integer  "state_id"
    t.integer  "metro_area_id"
    t.string   "login_slug"
    t.boolean  "notify_comments",                      :default => true
    t.boolean  "notify_friend_requests",               :default => true
    t.boolean  "notify_community_news",                :default => true
    t.integer  "country_id"
    t.boolean  "featured_writer",                      :default => false
    t.datetime "last_login_at"
    t.string   "zip"
    t.date     "birthday"
    t.string   "gender"
    t.boolean  "profile_public",                       :default => true
    t.integer  "activities_count",                     :default => 0
    t.integer  "sb_posts_count",                       :default => 0
    t.datetime "sb_last_seen_at"
    t.integer  "role_id"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                          :default => 0
    t.integer  "failed_login_count",                   :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "comments_count",                       :default => 0
  end

  add_index "users", ["activated_at"], :name => "index_users_on_activated_at"
  add_index "users", ["avatar_id"], :name => "index_users_on_avatar_id"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["featured_writer"], :name => "index_users_on_featured_writer"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["login_slug"], :name => "index_users_on_login_slug"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["vendor"], :name => "index_users_on_vendor"

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "choice_id"
    t.datetime "created_at"
  end

end
