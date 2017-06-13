require 'json'

class Video
  attr_accessor :title, :views, :link, :thumbnail, :published_at, :likes, :dislikes

  def initialize(data)
    data.each {|key, value| public_send("#{key}=", value)}
  end

  class << self
    def file_to_json(file)
      read_file = File.read(file)
      JSON.parse(read_file)
    end

    def initialize_from(file)
      json = file_to_json(file)
      json["videos"].map{ |datum| Video.new(datum) }
    end

    def highest_pc_likes(videos)
      data_hash = videos.map do | datum |
        total = datum.likes + datum.dislikes
        percentage = (datum.likes / total.to_f) * 100
        {datum.title => percentage}
      end
      most_popular = data_hash.sort_by {|_key, value| value}.first
      puts "'#{most_popular.keys[0]}' has the highest % of likes vs. dislikes (#{most_popular.values[0].round(3)}%)"
    end
  end
end
