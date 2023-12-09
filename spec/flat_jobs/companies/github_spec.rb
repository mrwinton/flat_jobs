# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Github do
  describe "#fetch_data", :vcr do
    it "returns data" do
      result = FlatJobs::Companies::Github.new.fetch_data

      expect(result).not_to be_empty
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Github.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::JSON)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      data = <<~JSON
        {
          "jobs": [
            {
              "data": {
                "req_id": "123",
                "title": "Staff Software Engineer",
                "description": "Description",
                "location_name": "US Remote",
                "apply_url": "http://example.com"
              }
            }
          ]
        }
      JSON

      result = FlatJobs::Companies::Github.new.parse_jobs(data)

      expect(result).to eq("github,123,Staff Software Engineer,US Remote,http://example.com,Description\n")
    end
  end
end
