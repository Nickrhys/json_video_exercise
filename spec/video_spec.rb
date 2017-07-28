require 'video'

describe "Video" do

  context "with a valid video" do
    let(:valid_video) do
      { "title" => "vid 1", "likes" => 8, "dislikes" => 2, "views" => 30, "published_at" => 1.hour.ago.to_s }
    end

    it "works" do
      video = Video.new(valid_video)
      expect(video.title).to eq "vid 1"
    end
  end

  context "with a valid heading" do
    let(:invalid_key) do
      { "invalid" => "vid 1", "likes" => 8, "dislikes" => 2, "views" => 30, "published_at" => 1.hour.ago.to_s }
    end

    it "raises error" do
      expect{Video.new(invalid_key)}.to raise_error("invalid heading")
    end
  end

  context "with a empty string value" do
    let(:invalid_value) do
      { "title" => "", "likes" => 8, "dislikes" => 2, "views" => 30, "published_at" => 1.hour.ago.to_s }
    end

    it "raises error" do
      expect{Video.new(invalid_value)}.to raise_error("content cannot be nil")
    end
  end
end
