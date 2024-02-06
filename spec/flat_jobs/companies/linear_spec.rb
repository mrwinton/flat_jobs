# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Linear do
  describe "#fetch_data", vcr: "linear_data" do
    it "returns data" do
      result = FlatJobs::Companies::Linear.new.fetch_data

      expect(result).not_to be_empty
    end

    it "returns nil when no data element is found" do
      result = FlatJobs::Companies::Linear.new.fetch_data(data_path: "random_path")

      expect(result).to be_nil
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Linear.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::HTML)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      response = vcr_response_data(vcr: "linear_data").first
      data_path = "//h4[contains(text(), 'Engineering')]/parent::div"
      doc = Nokogiri::HTML(response)
      data_element = doc.at_xpath(data_path)

      result = FlatJobs::Companies::Linear.new.parse_jobs(data_element.to_html)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("linear")
      expect(job.id).to eq("0ba80a46-e912-4a66-9231-b2d609b2c48d")
      expect(job.title).to eq("Senior - Staff Mobile Engineer (iOS)")
      expect(job.url).to eq("https://linear.app/careers/0ba80a46-e912-4a66-9231-b2d609b2c48d")
      expect(job.location).to eq("North America →")
      expect(job.notes).to be_nil
    end
  end
end
