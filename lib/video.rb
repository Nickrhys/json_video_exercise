class Video

  attr_accessor :title, :views, :link, :thumbnail, :published_at, :likes, :dislikes

  def initialize(video)
    @title = video['title']
    @views = video['views']
    @link = video['link']
    @thumbnail = video['thumbnail']
    @published_at = video['published_at']
    @likes = video['likes']
    @dislikes = video['dislikes']
  end
end
