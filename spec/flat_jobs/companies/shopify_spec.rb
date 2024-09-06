# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Shopify do
  describe "#fetch_data", vcr: "shopify_data" do
    it "returns data" do
      result = FlatJobs::Companies::Shopify.new.fetch_data

      expect(result).not_to be_empty
    end

    it "returns nil when data cannot be resolved" do
      result = FlatJobs::Companies::Shopify.new.fetch_data(pattern: /bad_pattern/)

      expect(result).to eq(nil)
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
      doc = Nokogiri::HTML(data)
      script_elements = doc.css('script')
      pattern = /window.__remixContext\s*=\s*({.*?});/m
      script_elements
        .map(&:content)
        .find { |content| content =~ pattern }

      result = FlatJobs::Companies::Shopify.new.parse_jobs($1)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("shopify")
      expect(job.id).to eq("f420b831-2186-4c69-bab0-82d779354386")
      expect(job.title).to eq("Engineering Internships, Winter 2025")
      expect(job.url).to eq("https://www.shopify.com/careers?ashby_jid=4c5d6050-9a66-4b7e-8873-13b892846e66")
      expect(job.location).to eq("Americas")
      expect(job.notes).to eq("")
    end
  end
end
