# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Shopify do
  describe "#fetch_data", vcr: "shopify_data" do
    it "returns data" do
      result = FlatJobs::Companies::Shopify.new.fetch_data

      expect(result).not_to be_empty
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Shopify.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::JSON)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      data = vcr_response_data(vcr: "shopify_data").first

      result = FlatJobs::Companies::Shopify.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("shopify")
      expect(job.id).to eq("743999956550023")
      expect(job.title).to eq("Staff Developer - Mobile Engineering")
      expect(job.url).to eq("https://api.smartrecruiters.com/v1/companies/Shopify/postings/743999956550023")
      expect(job.location).to eq("London, England")
      expect(job.notes).to match("Mid-Senior Level")
    end
  end
end
