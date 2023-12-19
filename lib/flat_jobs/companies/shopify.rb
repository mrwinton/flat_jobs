# frozen_string_literal: true

module FlatJobs
  module Companies
    class Shopify < FlatJobs::Company
      FlatJobs.register_company(:shopify, new)

      def fetch_data
        body = TAGS.to_query("tags")
        opts = {
          url: URL,
          body: body,
          headers: HEADERS
        }

        FlatJobs::Client.post(**opts).body
      end

      def data_file_type
        FileType::JSON
      end

      def parse_jobs(data)
        data = JSON.parse(data, symbolize_names: true)

        FlatJobs::WipJob.new(company: company_name, count: data[:postings].count).to_csv
      end

      private

      URL = "https://www.shopify.com/careers/disciplines/engineering?_data=pages%2F%28%24locale%29%2Fcareers%2Fdisciplines%2Fengineering"
      private_constant :URL

      TAGS = [
        "Software Engineering",
        "Backend Engineering",
        "Can hold your own",
        "Enough experience to mentor",
        "Team problem solver",
        "Strategic and universal problem-solver",
        "Technical influencer",
        "Product dreamer and shipper",
        "GraphQL",
        "MySQL",
        "Ruby",
        "Rails",
        "Develop a career",
        "Teach and coach others",
        "Caused a production outage",
        "Denied CTO’s diff",
        "Pushed directly to main",
        "Deleted 1000+ lines of code",
        "Contributed 100+ lines to open source",
        "Woke up in the middle of the night by oncall",
        "AI",
        "Risk Taker",
        "Process Instigator",
        "Curious Questioner",
        "Corporate Climber",
        "Serial Entrepreneur",
        "Career Shapeshifter",
        "High-rung Thinker",
        "Outlier",
        "EMEA",
        "quest-checkboxes"
      ]
      private_constant :TAGS

      HEADERS = {
        "authority" => "www.shopify.com",
        "accept" => "*/*",
        "accept-language" => "en-US,en;q=0.9",
        "dnt" => "1",
        "origin" => "https://www.shopify.com",
        "referer" => "https://www.shopify.com/careers/disciplines/engineering",
        "content-type" => "application/x-www-form-urlencoded;charset=UTF-8"
      }
      private_constant :HEADERS
    end
  end
end
