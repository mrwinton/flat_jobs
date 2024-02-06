# frozen_string_literal: true

module FlatJobs
  module Companies
    class Thoughtbot < FlatJobs::Company
      FlatJobs.register_company(:thoughtbot, new)

      def fetch_data(data_path: "section#jobs")
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
        doc.css("li.job").map { |job| parse_job(job) }
      end

      private

      THOUGHTBOT_URL = "https://thoughtbot.com"
      private_constant :THOUGHTBOT_URL

      REQUEST_OPTS = {
        url: "#{THOUGHTBOT_URL}/jobs",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def parse_job(job)
        job_url = THOUGHTBOT_URL + job.at_css("a")["href"]
        job_id = job_url.split("/").last
        job_title = job.at_css("a").text
        job_location = job["data-region"]

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
