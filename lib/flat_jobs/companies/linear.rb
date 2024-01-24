# frozen_string_literal: true

require "nokogiri"

module FlatJobs
  module Companies
    class Linear < FlatJobs::Company
      FlatJobs.register_company(:linear, new)

      def fetch_data(data_path: "script#__NEXT_DATA__")
        response = FlatJobs::Client.get(**REQUEST_OPTS)
        doc = Nokogiri::HTML(response.body)
        data_element = doc.at_css(data_path)

        if data_element.present?
          JSON.parse(data_element.content, symbolize_names: true).dig(*JOBS_PATH).to_json
        else
          raise FlatJobs::Error.new("Data element not found")
        end
      end

      def data_file_type
        FileType::JSON
      end

      def parse_jobs(data)
        JSON.parse(data, symbolize_names: true)
          .map { |_, jobs| jobs }.flatten
          .map { |job| parse_job(job) }
      end

      private

      REQUEST_OPTS = {
        url: "https://linear.app/careers",
        params: {},
        headers: {
          "Content-Type" => "text/html"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      JOBS_PATH = %i[props pageProps page prefooter jobs Engineering]
      private_constant :JOBS_PATH

      def parse_job(job)
        FlatJobs::Job.new(
          company: company_name,
          id: job[:id],
          title: job.dig(:title),
          location: job.dig(:location),
          url: job.dig(:jobUrl),
          notes: nil
        )
      end
    end
  end
end
