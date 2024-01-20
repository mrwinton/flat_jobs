# frozen_string_literal: true

module FlatJobs
  module Companies
    class Gitlab < FlatJobs::Company
      FlatJobs.register_company(:gitlab, new)

      def fetch_data(data_path: "//h4[contains(text(), 'Development')]/parent::section")
        response = FlatJobs::Client.get(**REQUEST_OPTS)
        doc = Nokogiri::HTML(response.body)
        data_element = doc.at_xpath(data_path)

        if data_element.present?
          data_element.to_html
        end
      end

      def data_file_type
        FileType::HTML
      end

      def parse_jobs(data)
        doc = Nokogiri::HTML(data)
        doc.css(".opening").map { |job| parse_job(job) }
      end

      private

      GREENHOUSE_URL = "https://boards.greenhouse.io"
      private_constant :GREENHOUSE_URL

      REQUEST_OPTS = {
        url: "#{GREENHOUSE_URL}/gitlab",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def parse_job(job)
        job_url = GREENHOUSE_URL + job.at_css("a")["href"]
        job_id = job_url.split("/").last
        job_title = job.at_css("a").text
        job_location = job.at_css(".location").text

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
