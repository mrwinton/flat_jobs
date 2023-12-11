# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Linear do
  describe "#fetch_data", vcr: "linear_data" do
    it "returns data" do
      result = FlatJobs::Companies::Linear.new.fetch_data

      expect(result).not_to be_empty
    end

    it "raises an error when no data element is found" do
      expect do
        FlatJobs::Companies::Linear.new.fetch_data(data_path: "random_path")
      end.to raise_error(FlatJobs::Error, "Data element not found")
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Linear.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::JSON)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      response = vcr_response_data(vcr: "linear_data").first
      data = Nokogiri::HTML(response).at_css("script#__NEXT_DATA__").content

      result = FlatJobs::Companies::Linear.new.parse_jobs(data)

      expect(result.lines.count).not_to be_zero
      expect(result.lines.first).to eq("linear,0d1b715f-5de3-4924-87f1-d64e566cd065,Senior - Staff Mobile Engineer (Android),North America,https://jobs.ashbyhq.com/Linear/0d1b715f-5de3-4924-87f1-d64e566cd065,\n")
    end
  end
end
