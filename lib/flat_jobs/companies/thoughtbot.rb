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
          data_element.content
        else
          raise FlatJobs::Error.new("Data element not found")
        end
      end

      def data_file_type
        FileType::HTML
      end

      def parse_jobs(data)
        jobs_empty = data.include?("We currently have no open positions.")
        jobs_count = jobs_empty ? 0 : 1

        FlatJobs::NullJob.new(company: company_name, count: jobs_count).to_csv
      end

      REQUEST_OPTS = {
        url: "https://thoughtbot.com/jobs",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS
    end
  end
end
