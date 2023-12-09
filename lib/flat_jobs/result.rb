# frozen_string_literal: true

module FlatJobs
  class Result
    attr_reader :success, :value

    def success?
      success == true
    end

    def failure?
      !success?
    end

    class Success < Result
      def initialize(value)
        @value = value
        @success = true
      end
    end

    class Failure < Result
      def initialize(value)
        @value = value
        @success = false
      end
    end
  end
end
