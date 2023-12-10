# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Linear do
  describe "#fetch_data", :vcr do
    it "returns data" do
      result = FlatJobs::Companies::Linear.new.fetch_data

      expect(result).not_to be_empty
    end

    it "raises an error when no data element is found", :vcr do
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
      data = <<~JSON
        {
          "props": {
            "pageProps": {
              "page": {
                "prefooter": {
                  "jobs": {
                    "Engineering": {
                      "Senior Staff Engineer": [
                        {
                          "id": "123abc",
                          "title": "Senior Staff Engineer",
                          "location": "North America",
                          "jobUrl": "https://jobs.ashbyhq.com/Linear/123",
                          "applyUrl": "https://jobs.ashbyhq.com/Linear/456/application",
                          "isListed": true,
                          "department": "Engineering"
                        }
                      ]
                    }
                  }
                }
              }
            }
          }
        }
      JSON

      result = FlatJobs::Companies::Linear.new.parse_jobs(data)

      expect(result).to eq("linear,123abc,Senior Staff Engineer,North America,https://jobs.ashbyhq.com/Linear/123,\n")
    end
  end
end
