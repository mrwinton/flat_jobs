# frozen_string_literal: true

module FlatJobs
  module Companies
    class Shopify < FlatJobs::Company
      FlatJobs.register_company(:Shopify, new)

      def fetch_data(pattern: /window.__remixContext\s*=\s*({.*?});/m)
        response = FlatJobs::Client.get(**REQUEST_OPTS)
        doc = Nokogiri::HTML(response.body)
        script_elements = doc.css('script')
        script_elements
          .map(&:content)
          .find { |content| content =~ pattern }
          .then { |match| match ? $1 : nil }
      end

      def data_file_type
        FileType::JSON
      end

      def parse_jobs(data)
        json = JSON.parse(data, symbolize_names: true)
        json.dig(:state, :loaderData, :'pages/shopify.com/($locale)/careers', :jobPostingsWithJobs)
          .map { |job| parse_job(job) if engineering_job?(job) }
          .compact
      end

      private

      URL = "https://www.shopify.com/careers#Engineering"
      private_constant :URL

      REQUEST_OPTS = {
        url: "#{URL}",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def engineering_job?(job)
        job.dig(:jobPosting, :teamName) == "Engineering"
      end

      def parse_job(job)
        job_id = job.dig(:jobPosting, :jobId)
        job_url = job.dig(:jobPosting, :applyLink)
        job_title = job.dig(:jobPosting, :title)
        job_location = job.dig(:jobPosting, :locationName)

        FlatJobs::Job.new(
          company: company_name,
          id: job_id,
          title: job_title,
          location: job_location,
          url: job_url,
          notes: ""
        )
      end
    end
  end
end
