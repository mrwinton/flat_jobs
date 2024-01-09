# frozen_string_literal: true

module FlatJobs
  module Companies
    class WorkOS < FlatJobs::Company
      FlatJobs.register_company(:work_os, new)

      def fetch_data
        FlatJobs::Client.get(**REQUEST_OPTS).body
      end

      def data_file_type
        FileType::HTML
      end

      def parse_jobs(data)
        doc = Nokogiri::HTML(data)
        doc.at_xpath("//h3[contains(text(), 'Engineering')]/following-sibling::div")
          .xpath("//div[@role='listitem']")
          .map { |job| parse_job(job) }
      end

      private

      REQUEST_OPTS = {
        url: "https://workos.com/careers#open-positions",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def parse_job(job)
        job_url = job.at_css("a")["href"]
        job_id = job_url.split("/").last
        job_title = job.at_css(".jobs-item-title").text
        job_location = job.at_css(".jobs-item-left .text-small").text

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
