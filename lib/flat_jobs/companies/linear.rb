# frozen_string_literal: true

require "nokogiri"

module FlatJobs
  module Companies
    class Linear < FlatJobs::Company
      FlatJobs.register_company(:linear, new)

      def fetch_data(data_path: "//h4[contains(text(), 'Engineering')]/parent::div")
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
        doc.css("li").map { |role| parse_role(role) }.flatten
      end

      private

      LINEAR_URL = "https://linear.app"
      private_constant :LINEAR_URL

      REQUEST_OPTS = {
        url: "#{LINEAR_URL}/careers",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def parse_role(role)
        job_title = role.at_css("p").text
        job_links = role.css("a")

        job_links.map do |job_link|
          job_url = LINEAR_URL + job_link["href"]
          job_id = job_url.split("/").last
          job_location = job_link.text

          FlatJobs::Job.new(
            company: company_name,
            id: job_id,
            title: job_title,
            location: job_location,
            url: job_url,
            notes: nil
          )
        end
      end
    end
  end
end
