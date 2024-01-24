# frozen_string_literal: true

module FlatJobs
  module Companies
    class Github < FlatJobs::Company
      FlatJobs.register_company(:github, new)

      def fetch_data
        response = FlatJobs::Client.get(**REQUEST_OPTS)
        data = JSON.parse(response.body, symbolize_names: true)
        data.delete(:meta_data)
        data.to_json
      end

      def data_file_type
        FileType::JSON
      end

      def parse_jobs(data)
        json = JSON.parse(data, symbolize_names: true)
        json[:jobs].map { |job| parse_job(job) }
      end

      private

      REQUEST_OPTS = {
        url: "https://githubinc.jibeapply.com/api/jobs",
        params: {
          page: "1",
          categories: "Engineering"
        },
        headers: {
          "Content-Type" => "application/json"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def parse_job(job)
        FlatJobs::Job.new(
          company: company_name,
          id: job.dig(:data, :req_id),
          title: job.dig(:data, :title),
          location: job.dig(:data, :location_name),
          url: job.dig(:data, :apply_url),
          notes: job.dig(:data, :description)
        )
      end
    end
  end
end
