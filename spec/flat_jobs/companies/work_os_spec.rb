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

      result = FlatJobs::Companies::WorkOS.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("work_os")
      expect(job.id).to eq("dfde45ea-18fe-4aef-9660-0374f13ebe1c")
      expect(job.title).to eq("Product Designer")
      expect(job.url).to eq("https://jobs.lever.co/workos/dfde45ea-18fe-4aef-9660-0374f13ebe1c")
      expect(job.location).to eq("Americas and European time zones")
      expect(job.notes).to eq("")
    end
  end
end
