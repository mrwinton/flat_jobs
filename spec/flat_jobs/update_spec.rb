# frozen_string_literal: true

require "fakefs/spec_helpers"

RSpec.describe FlatJobs::Update do
  describe ".call" do
    let(:data_path) { File.expand_path("../../../data", __FILE__) }

    around(:each) do |example|
      FakeFS do
        FakeFS::FileSystem.clone(data_path)

        example.run
      end
    end

    it "removes existing files and saves updated files" do
      File.write("#{data_path}/bronze/fake_company.json", "content")
      File.write("#{data_path}/silver/fake_company.csv", "content")
      File.write("#{data_path}/gold/test.csv", "content")
      fake_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          "fake,csv,data\n"
        end

        def self.name
          "FakeCompany"
        end
      end
      fake_company = fake_company_class.new

      FlatJobs::Update.call(companies: {fake: fake_company}, io: StringIO.new)

      expect(File.read("#{data_path}/bronze/fake_company.json")).to eq("{title: 'fake'}")
      expect(File.read("#{data_path}/silver/fake_company.csv")).to eq("fake,csv,data\n")
      expect(File.read("#{data_path}/gold/flat_jobs.csv")).to eq("fake,csv,data\n")
    end

    it "merges silver data files into a single gold data file" do
      a_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          "a,csv,data\n"
        end

        def self.name
          "ACompany"
        end
      end
      b_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          "b,csv,data\n"
        end

        def self.name
          "BCompany"
        end
      end
      a_company = a_company_class.new
      b_company = b_company_class.new

      FlatJobs::Update.call(companies: {a: a_company, b: b_company}, io: StringIO.new)

      expect(File.read("#{data_path}/gold/flat_jobs.csv")).to eq("a,csv,data\nb,csv,data\n")
    end

    it "ignores disabled companies" do
      a_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          "a,csv,data\n"
        end

        def self.name
          "ACompany"
        end
      end
      b_company_class = Class.new(FlatJobs::Company) do
        def disabled?
          true
        end
      end
      a_company = a_company_class.new
      b_company = b_company_class.new

      FlatJobs::Update.call(companies: {a: a_company, b: b_company}, io: StringIO.new)

      expect(File.read("#{data_path}/gold/flat_jobs.csv")).to eq("a,csv,data\n")
    end

    it "ignores companies that raise errors" do
      a_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          "a,csv,data\n"
        end

        def self.name
          "ACompany"
        end
      end
      b_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          raise FlatJobs::Error.new("error")
        end

        def self.name
          "BCompany"
        end
      end
      a_company = a_company_class.new
      b_company = b_company_class.new

      FlatJobs::Update.call(companies: {a: a_company, b: b_company}, io: StringIO.new)

      expect(File.read("#{data_path}/gold/flat_jobs.csv")).to eq("a,csv,data\n")
    end
  end
end
