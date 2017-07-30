require_relative "run_video"

class RunScript

  def menu
    puts "Welcome to the Peg statistics script for Zoella's videos."
    puts "Please choose from one of the following options:"
    puts "1. The title of the video with the highest percentage of likes vs. dislikes"
    puts "2. The average (mean) percentage of likes vs. dislikes for all videos"
    puts "3. The total number of views for all videos"
    puts "4. The average (mean) time interval between all videos"
    puts "0. Exit script"
  end

  def choice(input, video_analyser)
    case input
    when "1"
      video_analyser.highest_pc_likes
    when "2"
      video_analyser.mean_average_likes
    when "3"
      video_analyser.total_views
    when "4"
      video_analyser.average_time_between
    when "0"
      exit
    else
      puts "I don't know what you mean, try again"
    end
  end

  def run
    video_analyser = VideoAnalyser.new('./video_data.json')
    loop do
      menu
      choice(STDIN.gets.chomp, video_analyser)
    end
  end
end
