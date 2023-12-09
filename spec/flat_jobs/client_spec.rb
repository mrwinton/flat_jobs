# frozen_string_literal: true

RSpec.describe FlatJobs::Client do
  describe ".get" do
    it "wraps Faraday" do
      faraday_spy = spy("Faraday")
      allow(Faraday).to receive(:new).and_return(faraday_spy)
      url = "test url"
      params = {test: "params"}
      headers = {test: "headers"}

      FlatJobs::Client.get(url: url, params: params, headers: headers)

      expect(Faraday).to have_received(:new)
      expect(faraday_spy).to have_received(:get).with(url, params, headers)
    end

    it "raises 'FlatJobs::Error' on error" do
      stubs = Faraday::Adapter::Test::Stubs.new
      stubs.get("/api") do
        [
          404,
          {"Content-Type": "application/javascript"},
          "{}"
        ]
      end

      expect {
        FlatJobs::Client.get(url: "http://example.com/api", params: {}, headers: {}, stubs: stubs)
      }.to raise_error(FlatJobs::Error, "the server responded with status 404")
    end
  end

  describe ".post" do
    it "wraps Faraday" do
      faraday_spy = spy("Faraday")
      allow(Faraday).to receive(:new).and_return(faraday_spy)
      url = "test url"
      body = "test body"
      headers = {test: "headers"}

      FlatJobs::Client.post(url: url, body: body, headers: headers)

      expect(Faraday).to have_received(:new)
      expect(faraday_spy).to have_received(:post).with(url, body, headers)
    end

    it "raises 'FlatJobs::Error' on error" do
      stubs = Faraday::Adapter::Test::Stubs.new
      stubs.post("/api") do
        [
          404,
          {"Content-Type": "application/javascript"},
          "{}"
        ]
      end

      expect {
        FlatJobs::Client.post(url: "http://example.com/api", body: nil, headers: {}, stubs: stubs)
      }.to raise_error(FlatJobs::Error, "the server responded with status 404")
    end
  end
end
