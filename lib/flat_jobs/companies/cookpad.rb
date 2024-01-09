# frozen_string_literal: true

module FlatJobs
  module Companies
    class Cookpad < FlatJobs::Company
      FlatJobs.register_company(:cookpad, new)

      def fetch_data
        FlatJobs::Client.post(**REQUEST_OPTS).body
      end

      def data_file_type
        FileType::JSON
      end

      def parse_jobs(data)
        [null_job(data)]
      end

      private

      REQUEST_OPTS = {
        url: "https://apply.workable.com/api/v3/accounts/cookpad/jobs",
        body: '{"query":"","location":[],"department":[],"worktype":[],"remote":[],"workplace":[]}',
        headers: {
          "Content-Type" => "application/json"
        }
      }.freeze
      private_constant :REQUEST_OPTS

      def null_job(data)
        json = JSON.parse(data, symbolize_names: true)
        notes = "#{json[:total]} jobs found"

        FlatJobs::NullJob.new(company: company_name, notes: notes)
      end
    end
  end
end
