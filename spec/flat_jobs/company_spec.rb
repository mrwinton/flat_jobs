# frozen_string_literal: true

require "fakefs/spec_helpers"

RSpec.describe FlatJobs::Company do
  describe "#update" do
    let(:data_path) { File.expand_path("../../../data", __FILE__) }

    around(:each) do |example|
      FakeFS do
        FakeFS::FileSystem.clone(data_path)

        example.run
      end
    end

    it "returns jobs in a success result" do
      fake_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          job = FlatJobs::NullJob.new(company: "fake", notes: "notes")
          [job]
        end

        def self.name
          "FakeCompany"
        end
      end
      fake_company = fake_company_class.new

      result = fake_company.update

      expect(result).to be_success
      expect(result.value).to eq("fake,-,-,-,-,notes\n")
    end

    it "returns jobs ordered by id" do
      fake_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          job2 = FlatJobs::Job.new(
            company: "test_co",
            id: 2,
            title: "Engineer",
            location: "Sweden",
            url: "example.com",
            notes: nil
          )
          job1 = FlatJobs::Job.new(
            company: "test_co",
            id: 1,
            title: "Engineer",
            location: "Sweden",
            url: "example.com",
            notes: nil
          )
          [job2, job1]
        end

        def self.name
          "FakeCompany"
        end
      end
      fake_company = fake_company_class.new

      result = fake_company.update

      expect(result).to be_success
      expect(result.value).to eq("test_co,1,Engineer,Sweden,example.com,\ntest_co,2,Engineer,Sweden,example.com,\n")
    end

    it "returns when no jobs are present" do
      fake_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          []
        end

        def self.name
          "FakeCompany"
        end
      end
      fake_company = fake_company_class.new

      result = fake_company.update

      expect(result).to be_success
      expect(result.value).to eq("fake_company,-,-,-,-,0 jobs found\n")
    end

    it "saves bronze data" do
      fake_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          job = FlatJobs::NullJob.new(company: "fake", notes: "notes")
          [job]
        end

        def self.name
          "FakeCompany"
        end
      end
      fake_company = fake_company_class.new

      fake_company.update

      expect(File.read("#{data_path}/bronze/fake_company.json")).to eq("{title: 'fake'}")
    end

    it "saves silver data" do
      fake_company_class = Class.new(FlatJobs::Company) do
        def fetch_data
          "{title: 'fake'}"
        end

        def data_file_type
          "json"
        end

        def parse_jobs(data)
          job = FlatJobs::NullJob.new(company: "fake", notes: "notes")
          [job]
        end

        def self.name
          "FakeCompany"
        end
      end
      fake_company = fake_company_class.new

      fake_company.update

      expect(File.read("#{data_path}/silver/fake_company.csv")).to eq("company,id,title,location,url,notes\nfake,-,-,-,-,notes\n")
    end

    context "when an error is raised" do
      it "returns the error in a failure result" do
        fake_company_class = Class.new(FlatJobs::Company) do
          def fetch_data
            "{title: 'fake'}"
          end

          def data_file_type
            "json"
          end

          def parse_jobs(data)
            raise FlatJobs::Error.new("fake error")
          end

          def self.name
            "FakeCompany"
          end
        end
        fake_company = fake_company_class.new

        result = fake_company.update

        expect(result).not_to be_success
        expect(result.value).to eq("fake error")
      end
    end
  end

  describe "#fetch_data" do
    it "raises an error" do
      company = FlatJobs::Company.new

      expect { company.fetch_data }.to raise_error(FlatJobs::Error, "'fetch_data' not implemented")
    end
  end

  describe "#data_file_type" do
    it "raises an error" do
      company = FlatJobs::Company.new

      expect { company.data_file_type }.to raise_error(FlatJobs::Error, "'data_file_type' not implemented")
    end
  end

  describe "#parse_jobs" do
    it "raises an error" do
      company = FlatJobs::Company.new

      expect { company.parse_jobs([]) }.to raise_error(FlatJobs::Error, "'parse_jobs' not implemented")
    end
  end

  describe "#enabled?" do
    it "returns false when disabled by env var" do
      allow(ENV).to receive(:key?).with("FAKE_COMPANY_DISABLED").and_return(true)
      fake_company_class = Class.new(FlatJobs::Company) do
        def self.name
          "FakeCompany"
        end
      end
      fake_company = fake_company_class.new

      result = fake_company.enabled?

      expect(result).to eq(false)
    end

    it "returns true when not disabled by env var" do
      fake_company_class = Class.new(FlatJobs::Company) do
        def self.name
          "FakeCompany"
        end
      end
      fake_company = fake_company_class.new

      result = fake_company.enabled?

      expect(result).to eq(true)
    end
  end
end
