# frozen_string_literal: true

module FlatJobs
  module Companies
    class WorkOS < FlatJobs::Company
      FlatJobs.register_company(:work_os, new)

      def fetch_data(data_path: "//*[@class='w-tab-pane w--tab-active']//h3[contains(text(), 'Engineering')]/following-sibling::div")
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
        doc.xpath("//div[@role='listitem']")
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
