require 'run_video'

describe "VideoWrapper" do

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
      expect(File).to receive(:read).and_return(json_file).twice
      expect(JSON).to receive(:parse).with(json_file).and_return(json_file).twice
    end

    let(:video_wrapper) { VideoWrapper.new(json_file) }

    it "returns an Array of Videos" do
      expect(video_wrapper).to be_an_instance_of(VideoWrapper)
      expect(video_wrapper.videos).to be_a Array
    end

    it "outputs the video with the most likes vs. dislikes" do
      expect{video_wrapper.highest_pc_likes}.to output("'vid 1' has the highest % of likes vs. dislikes (80.0%)\n").to_stdout
    end

    it "outputs the average likes and dislikes" do
      expect{video_wrapper.mean_average_likes}.to output("The mean average likes vs. dislikes per video is 70.0%\n").to_stdout
    end

    it "returns the % of likes vs. dislikes per video" do
      expect(video_wrapper.percentage_of_likes_per_video).to eq({"vid 1" => 80.0, "vid 2" => 70.0, "vid 3" => 60.0 })
    end

    it "outputs the total views" do
      expect{video_wrapper.total_views}.to output("The total number of views for all videos is 90\n").to_stdout
    end

    it "works out the average time between videos" do
      expect{video_wrapper.average_time_between}.to output("The mean average time interval (in hours, minutes and seconds) between all videos is 01:00:00\n").to_stdout
    end

    it "adds commas to long numbers" do
      expect(video_wrapper.add_commas_to("1234567890")).to eq("1,234,567,890")
    end

    it "changes seconds into a string with time displayed by hours, minutes and seconds" do
      expect(video_wrapper.time_as_string(3666)).to eq "01:01:06"
    end
  end
end
