require 'video'

describe "Video" do

  let(:json_file) do
    {
      "videos" => [
        { "title" => "vid 1", "likes" => 8, "dislikes" => 2, "views" => 30, "published_at" => 1.hour.ago.to_s},
        { "title" => "vid 2", "likes" => 7, "dislikes" => 3, "views" => 35, "published_at" => 2.hours.ago.to_s },
        { "title" => "vid 3", "likes" => 6, "dislikes" => 4, "views" => 25, "published_at" => 3.hours.ago.to_s },
      ]
    }
  end

  describe "extracting information from the JSON file" do
    before do
      expect(File).to receive(:read).and_return(json_file)
      expect(JSON).to receive(:parse).with(json_file).and_return(json_file)
    end

    let(:videos) { Video::initialize_from(json_file) }

    it "returns an Array of Videos" do
      expect(videos.first).to be_an_instance_of(Video)
      expect(videos).to be_a Array
    end

    it "outputs the video with the most likes vs. dislikes" do
      expect{Video::highest_pc_likes(videos)}.to output("'vid 1' has the highest % of likes vs. dislikes (80.0%)\n").to_stdout
    end

    it "outputs the average likes and dislikes" do
      expect{Video::mean_average_likes(videos)}.to output("The mean average likes vs. dislikes per video is 70.0%\n").to_stdout
    end
  end
end
