# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::WorkOS do
  describe "#fetch_data", vcr: "work_os_data" do
    it "returns data" do
      result = FlatJobs::Companies::WorkOS.new.fetch_data

      expect(result).not_to be_empty
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::WorkOS.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::HTML)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      data = vcr_response_data(vcr: "work_os_data").first
      doc = Nokogiri::HTML(data)
      data_element = doc.at_xpath("//*[@class='w-tab-pane w--tab-active']//h3[contains(text(), 'Engineering')]/following-sibling::div")

      result = FlatJobs::Companies::WorkOS.new.parse_jobs(data_element.to_html)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("work_os")
      expect(job.id).to eq("90725c1f-c826-4520-946a-2c6ff6103882")
      expect(job.title).to eq("Engineering Manager - Infrastructure and Security")
      expect(job.url).to eq("https://jobs.lever.co/workos/90725c1f-c826-4520-946a-2c6ff6103882")
      expect(job.location).to eq("USA time zones")
      expect(job.notes).to eq("")
    end
  end
end
