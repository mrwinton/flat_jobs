# frozen_string_literal: true

RSpec.describe FlatJobs do
  it "has a version number" do
    expect(FlatJobs::VERSION).not_to be nil
  end

  describe ".update" do
    it "invokes `FlatJobs::Update`" do
      allow(FlatJobs::Update).to receive(:call)

      FlatJobs.update

      expect(FlatJobs::Update).to have_received(:call)
    end
  end
end
