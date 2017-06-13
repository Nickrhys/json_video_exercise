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
  end
end
