require 'json'
require 'time'
require "json-schema"
require_relative "video"

class VideoWrapper

  attr_accessor :videos

  def file_to_json(file)
    read_file = File.read(file)
    JSON.parse(read_file)
  end

  def initialize(file)
    json = file_to_json(file)
    json_schema = file_to_json('./lib/schema.json')
    @videos = []
    json["videos"].map do |video|
      if JSON::Validator.validate(json_schema, video) == true
        @videos << Video.new(video)
      else
        raise "Video not valid. Please check JSON"
      end
    end
  end

  def highest_pc_likes
    data_hash = percentage_of_likes_per_video
    most_popular = data_hash.sort_by { |title, pc| pc }.reverse.first
    puts "'#{most_popular[0]}' has the highest % of likes vs. dislikes (#{most_popular[1].round(3)}%)"
  end

  def mean_average_likes
    likes_percent = percentage_of_likes_per_video
    mean_average = likes_percent.map{ |pc| pc[1] }.flatten.inject(:+) / likes_percent.count
    puts "The mean average likes vs. dislikes per video is #{mean_average.round(3)}%"
  end

  def percentage_of_likes_per_video
    pc_hash = {}
    videos.map do | video |
      total = video.likes + video.dislikes
      percentage = (video.likes / total.to_f) * 100
      pc_hash[video.title] = percentage
    end
    pc_hash
  end

  def total_views
    views = videos.map{ |video| video.views }
    total = views.inject(:+)
    puts "The total number of views for all videos is #{add_commas_to(total)}"
  end

  def add_commas_to(number)
    number.to_s.reverse.scan(/\d{3}|.+/).join(",").reverse
  end

  def average_time_between
    dates = videos.map{ |video| Time.parse(video.published_at) }
    average_time = dates.each_cons(2).map { |date_1, date_2| date_1 - date_2 }.inject(:+) / (dates.length - 1)
    puts "The mean average time interval (in hours, minutes and seconds) between all videos is #{time_as_string(average_time.ceil)}"
  end

  def time_as_string(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end

  def script_menu
    puts "Welcome to the Peg statistics script for Zoella's videos."
    puts "Please choose from one of the following options:"
    puts "1. The title of the video with the highest percentage of likes vs. dislikes"
    puts "2. The average (mean) percentage of likes vs. dislikes for all videos"
    puts "3. The total number of views for all videos"
    puts "4. The average (mean) time interval between all videos"
    puts "0. Exit script"
  end

  def script_choice(input, videos)
    case input
    when "1"
      videos.highest_pc_likes
    when "2"
      videos.mean_average_likes
    when "3"
      videos.total_views
    when "4"
      videos.average_time_between
    when "0"
      exit
    else
      puts "I don't know what you mean, try again"
    end
  end
end

def run_script
  videos = VideoWrapper.new('./lib/video_data.json')
  loop do
    videos.script_menu
    videos.script_choice(STDIN.gets.chomp, videos)
  end
end