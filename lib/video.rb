require 'json'
require 'time'

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
      data_hash = percentage_of_likes_per_video(videos)
      most_popular = data_hash.sort_by {|key, value| value}.first
      puts "'#{most_popular.keys[0]}' has the highest % of likes vs. dislikes (#{most_popular.values[0].round(3)}%)"
    end

    def mean_average_likes(videos)
      likes_percent = percentage_of_likes_per_video(videos)
      mean_average = likes_percent.map(&:values).flatten.reduce(:+) / likes_percent.count
      puts "The mean average likes vs. dislikes per video is #{mean_average.round(3)}%"
    end

    def percentage_of_likes_per_video(data)
      data.map do | datum |
        total = datum.likes + datum.dislikes
        percentage = (datum.likes / total.to_f) * 100
        {datum.title => percentage}
      end
    end

    def total_views(videos)
      views = videos.map{ |video| video.views }
      total = views.reduce(:+)
      puts "The total number of views for all videos is #{add_commas_to(total)}"
    end

    def add_commas_to(number)
      number.to_s.reverse.scan(/\d{3}|.+/).join(",").reverse
    end

    def average_time_between(videos)
      dates = videos.map{ |video| Time.parse(video.published_at) }
      average_time = dates.each_cons(2).map { |d1, d2| d1 - d2 }.inject(:+) / (dates.length - 1)
      puts "The mean average time interval (in hours, minutes and seconds) between all videos is #{time_as_string(average_time.ceil)}"
    end

    def time_as_string(seconds)
      Time.at(seconds).utc.strftime("%H:%M:%S")
    end
  end
end
