# frozen_string_literal: true

module FlatJobs
  module Companies
    class Fly < FlatJobs::Company
      FlatJobs.register_company(:fly, new)

      def fetch_data(data_path: "main section")
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
        doc.css("article")
          .select { |job| engineering_job_present?(job) }
          .map { |job| parse_job(job) }
      end

      private

      FLY_URL = "https://fly.io"
      private_constant :FLY_URL

      ENGINEERING_KEY = "engineer"
      private_constant :ENGINEERING_KEY

      PRESENCE_KEY = "No positions available"
      private_constant :PRESENCE_KEY

      REQUEST_OPTS = {
        url: "#{FLY_URL}/jobs/",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def engineering_job_present?(job)
        job_text = job.text
        job_text.downcase.include?(ENGINEERING_KEY) && !job_text.include?(PRESENCE_KEY)
      end

      def parse_job(job)
        job_url = FLY_URL + job.at_css("a")["href"]
        job_id = job_url.split("/").last
        job_title = job.at_xpath("//dt[contains(text(), 'Position title')]/following-sibling::dd").content
        job_location = job.at_xpath("//dt[contains(text(), 'Work From')]/following-sibling::dd").text

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
