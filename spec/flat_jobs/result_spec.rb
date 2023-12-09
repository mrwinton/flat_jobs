# frozen_string_literal: true

RSpec.describe FlatJobs::Result::Success do
  describe "#success?" do
    it "returns true" do
      result = FlatJobs::Result::Success.new("hello world")

      expect(result.success?).to eq(true)
    end
  end

  describe "#failure?" do
    it "returns false" do
      result = FlatJobs::Result::Success.new("hello world")

      expect(result.failure?).to eq(false)
    end
  end

  it "returns the given value" do
    result = FlatJobs::Result::Success.new("hello world")

    expect(result).to have_attributes(value: "hello world")
  end
end

RSpec.describe FlatJobs::Result::Failure do
  describe "#success?" do
    it "returns false" do
      result = FlatJobs::Result::Failure.new("hello world")

      expect(result.success?).to eq(false)
    end
  end

  describe "#failure?" do
    it "returns true" do
      result = FlatJobs::Result::Failure.new("hello world")

      expect(result.failure?).to eq(true)
    end
  end

  it "returns the given value" do
    result = FlatJobs::Result::Failure.new("hello world")

    expect(result).to have_attributes(value: "hello world")
  end
end
