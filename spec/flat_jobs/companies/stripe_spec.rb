# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Stripe do
  describe "#fetch_data", vcr: "stripe_data" do
    it "returns data" do
      result = FlatJobs::Companies::Stripe.new.fetch_data

      expect(result).not_to be_empty
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Stripe.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::HTML)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      data = vcr_response_data(vcr: "stripe_data").first
      doc = Nokogiri::HTML(data)
      data_element = doc.at_css(".JobsListings__tableBody")

      result = FlatJobs::Companies::Stripe.new.parse_jobs(data_element.to_html)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("stripe")
      expect(job.id).to eq("5563735")
      expect(job.title).to eq("Backend Engineer, High Availability")
      expect(job.url).to eq("https://stripe.com/jobs/listing/backend-engineer-high-availability/5563735")
      expect(job.location).to eq("Seattle")
      expect(job.notes).to eq("")
    end
  end
end
