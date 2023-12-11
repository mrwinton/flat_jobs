# frozen_string_literal: true

module FlatJobs
  module FileHelper
    class << self
      def save_file(key, data, data_layer:, file_type:)
        path = build_path(key, data_layer, file_type)
        data = add_csv_header(data) if add_csv_header?(data_layer)

        File.write(path, data) if data.present?
      end

      def remove_files
        Dir.glob("#{data_path}/**/*.{#{file_types}}").each { |file| File.delete(file) }
      end

      private

      def build_path(key, data_layer, file_type)
        "#{data_path}/#{data_layer}/#{key}.#{file_type}"
      end

      def data_path
        File.expand_path("../../../data", __FILE__)
      end

      def file_types
        [FileType::CSV, FileType::JSON, FileType::HTML].join(",")
      end

      def add_csv_header(data)
        [FlatJobs::Job.keys, data].join if data.present?
      end

      def add_csv_header?(data_layer)
        [DataLayer::GOLD, DataLayer::SILVER].include?(data_layer)
      end
    end
  end
end
