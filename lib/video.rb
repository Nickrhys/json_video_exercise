class Video

  attr_accessor :title, :views, :link, :thumbnail, :published_at, :likes, :dislikes

  def initialize(video)
    validate(video)
    @title = video['title']
    @views = video['views']
    @link = video['link']
    @thumbnail = video['thumbnail']
    @published_at = video['published_at']
    @likes = video['likes']
    @dislikes = video['dislikes']
  end

  private

  def validate(video)
    video.each do |heading, content|
      raise "invalid heading" unless valid_keys.include?(heading)
      raise "content cannot be nil" if content.to_s.strip.empty?
    end
  end

  def valid_keys
    ['title', 'views', 'link', 'thumbnail', 'published_at', 'likes', 'dislikes']
  end
end
