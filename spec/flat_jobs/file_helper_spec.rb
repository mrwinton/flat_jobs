# frozen_string_literal: true

require "fakefs/spec_helpers"

RSpec.describe FlatJobs::FileHelper do
  let(:data_path) { File.expand_path("../../../data", __FILE__) }

  around(:each) do |example|
    FakeFS do
      FakeFS::FileSystem.clone(data_path)

      example.run
    end
  end

  describe ".save_file" do
    it "saves bronze data" do
      key = "test"
      data = "hello world"
      data_layer = FlatJobs::DataLayer::BRONZE
      file_type = FlatJobs::FileType::CSV
      expect { File.read("#{data_path}/bronze/test.csv") }.to raise_error(Errno::ENOENT)

      FlatJobs::FileHelper.save_file(key, data, data_layer: data_layer, file_type: file_type)

      expect(File.read("#{data_path}/bronze/test.csv")).to eq(data)
    end

    it "saves silver data" do
      key = "test"
      data = "hello world"
      data_layer = FlatJobs::DataLayer::SILVER
      file_type = FlatJobs::FileType::CSV
      expect { File.read("#{data_path}/silver/test.csv") }.to raise_error(Errno::ENOENT)

      FlatJobs::FileHelper.save_file(key, data, data_layer: data_layer, file_type: file_type)

      expect(File.read("#{data_path}/silver/test.csv")).to eq("company,id,title,location,url,notes\n" + data)
    end

    it "saves gold data" do
      key = "test"
      data = "hello world"
      data_layer = FlatJobs::DataLayer::GOLD
      file_type = FlatJobs::FileType::CSV
      expect { File.read("#{data_path}/gold/test.csv") }.to raise_error(Errno::ENOENT)

      FlatJobs::FileHelper.save_file(key, data, data_layer: data_layer, file_type: file_type)

      expect(File.read("#{data_path}/gold/test.csv")).to eq("company,id,title,location,url,notes\n" + data)
    end

    it "performs no-op with no data" do
      key = "empty"
      data = ""
      data_layer = FlatJobs::DataLayer::GOLD
      file_type = FlatJobs::FileType::CSV
      expect { File.read("#{data_path}/gold/empty.csv") }.to raise_error(Errno::ENOENT)

      FlatJobs::FileHelper.save_file(key, data, data_layer: data_layer, file_type: file_type)

      expect { File.read("#{data_path}/gold/empty.csv") }.to raise_error(Errno::ENOENT)
    end
  end

  describe ".remove_files" do
    it "removes the files in '/data'" do
      File.write("#{data_path}/bronze/test.csv", "content")
      File.write("#{data_path}/bronze/test.html", "content")
      File.write("#{data_path}/bronze/test.json", "content")
      File.write("#{data_path}/silver/test.csv", "content")
      File.write("#{data_path}/gold/test.csv", "content")

      FlatJobs::FileHelper.remove_files

      files = Dir.glob("#{data_path}/**/*.{csv,json,html}")
      expect(files).to be_empty
    end
  end
end
