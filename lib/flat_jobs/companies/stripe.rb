# frozen_string_literal: true

module FlatJobs
  module Companies
    class Stripe < FlatJobs::Company
      FlatJobs.register_company(:stripe, new)

      def fetch_data(data_path: ".JobsListings__tableBody")
        response = FlatJobs::Client.get(**REQUEST_OPTS)
        doc = Nokogiri::HTML(response.body)
        data_element = doc.at_css(data_path)

        if data_element.present?
          data_element.to_html
        end
      end

      def data_file_type
        FileType::HTML
      end

      def parse_jobs(data)
        doc = Nokogiri::HTML(data)
        doc.css(".TableRow").map { |job| parse_job(job) }
      end

      private

      STRIPE_URL = "https://stripe.com"
      private_constant :STRIPE_URL

      REQUEST_OPTS = {
        url: "#{STRIPE_URL}/jobs/search?teams=Banking+as+a+Service&teams=Climate&teams=Connect&teams=New+Financial+Products&teams=Payments&teams=Platform&teams=Revenue+%26+Financial+Automation&teams=Tax&teams=Terminal&remote_locations=Europe--Sweden+Remote",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def parse_job(job)
        job_title_element = job.at_css(".JobsListings__tableCell--title a")
        job_url = STRIPE_URL + job_title_element["href"]
        job_id = job_url.split("/").last
        job_title = job_title_element.content
        job_location_element = job.at_css(".JobsListings__locationDisplayName")
        job_location = job_location_element.content

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
