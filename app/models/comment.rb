#override CE comment model
class Comment

  belongs_to :commentable, :polymorphic => true, :counter_cache => 'comments_count'

end