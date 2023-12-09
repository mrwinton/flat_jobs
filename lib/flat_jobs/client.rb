# frozen_string_literal: true

require "faraday"

module FlatJobs
  class Client
    class << self
      def get(url:, params:, headers:, stubs: nil)
        request(:get, url, params, headers, stubs: stubs)
      end

      def post(url:, body:, headers:, stubs: nil)
        request(:post, url, body, headers, stubs: stubs)
      end

      private

      def request(verb, url, params_or_body, headers, stubs:)
        connection = build_connection(stubs)
        response = connection.public_send(verb, url, params_or_body, headers)
        build_response(response)
      rescue Faraday::Error => e
        raise FlatJobs::Error.new(e.message)
      end

      def build_connection(stubs)
        Faraday.new do |c|
          c.response :raise_error
          stubs ? c.adapter(:test, stubs) : c.adapter(Faraday.default_adapter)
        end
      end

      def build_response(response)
        Response.new(
          status: response.status,
          body: response.body
        )
      end
    end

    class Response
      attr_reader :status, :body

      def initialize(status:, body:)
        @status = status
        @body = body
      end
    end
  end
end
