require "rails_helper"

RSpec.describe DiaperBankClient do
  describe ".post_request" do
    it "provides net http request object for post actions" do
      client = DiaperBankClient.post_request(uri: "some_url", body: {})
      expect(client).to be_an_instance_of Net::HTTP::Post
    end
  end
end
