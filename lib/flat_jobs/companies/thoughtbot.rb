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
        [null_job(data)]
      end

      private

      REQUEST_OPTS = {
        url: "https://thoughtbot.com/jobs",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def null_job(data)
        jobs_empty = data.include?("We currently have no open positions.")
        notes = jobs_empty ? "0 jobs found" : "1+ jobs found"

        FlatJobs::NullJob.new(company: company_name, notes: notes)
      end
    end
  end
end
