# frozen_string_literal: true

module FlatJobs
  class Company
    def update
      data = fetch_data
      save_file(data, data_layer: DataLayer::BRONZE, file_type: data_file_type)

      jobs = parse(data)
      save_file(jobs, data_layer: DataLayer::SILVER, file_type: FileType::CSV)

      Result::Success.new(jobs)
    rescue FlatJobs::Error, StandardError => e
      Result::Failure.new(e.message)
    end

    def fetch_data
      raise FlatJobs::Error.new("'#{__method__}' not implemented")
    end

    def data_file_type
      raise FlatJobs::Error.new("'#{__method__}' not implemented")
    end

    def parse_jobs(data)
      raise FlatJobs::Error.new("'#{__method__}' not implemented")
    end

    def enabled?
      !disabled?
    end

    private

    def disabled?
      ENV.key?("#{company_name.upcase}_DISABLED")
    end

    def parse(data)
      jobs = parse_jobs(data).presence || null_data
      jobs.sort_by(&:id).map(&:to_csv).join
    end

    def null_data
      [FlatJobs::NullJob.new(company: company_name, notes: "0 jobs found")]
    end

    def save_file(data, data_layer:, file_type:)
      FileHelper.save_file(company_name, data, data_layer:, file_type:)
    end

    def company_name
      self.class.name.demodulize.underscore
    end
  end
end
