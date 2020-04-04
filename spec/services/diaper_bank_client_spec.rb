require "rails_helper"

RSpec.describe DiaperBankClient do
  describe ".post_request" do
    it "provides net http request object for post actions" do
      client = DiaperBankClient.post_request(uri: "some_url", body: {})
      expect(client).to be_an_instance_of Net::HTTP::Post
    end
  end

  describe '.get_available_items(diaper_bank_id)' do
    subject { described_class.get_available_items(diaper_bank_id) }
    let(:diaper_bank_id) { Faker::Number.number }
    let(:fake_routes) { instance_double('Routes.instances') }
    let(:fake_route) { instance_double('route') }

    before do
      allow(described_class).to receive(:routes).and_return(fake_routes)
      allow(fake_routes).to receive(:partner_requests).with(diaper_bank_id).and_return(fake_route)
    end

    context 'when the response code is 200' do
      let(:fake_response) { instance_double('response', code: '200', body: {status: Faker::Number.number}.to_json) }
      before do
        allow(described_class).to receive(:diaper_get_request).with(fake_route).and_return(fake_response)
      end

      it 'should return the parsed response body' do
        expect(subject).to eq(JSON.parse(fake_response.body))
      end
    end

    context 'when the response code is not 200' do
      let(:fake_response) { instance_double('response', code: '400') }

      before do
        allow(described_class).to receive(:diaper_get_request).with(fake_route).and_return(fake_response)
      end

      it 'should return a empty array' do
        expect(subject).to eq([])
      end
    end

  end

  describe '.diaper_get_request(uri)' do
    subject { described_class.diaper_get_request(uri) }
    let(:uri) { 'fake-uri' }
    let(:fake_request) { { } }
    let(:fake_https_client) { instance_double(Net::HTTP) }
    let(:fake_response) { { status: 'fake' } }

    before do
      fake_x_api_key = Faker::Number.number
      allow(ENV).to receive(:[]).with('DIAPERBANK_KEY').and_return(fake_x_api_key)
      allow(Net::HTTP::Get).to receive(:new).with(uri).and_return(fake_request)
      allow(described_class).to receive(:https).with(uri).and_return(fake_https_client)
      allow(fake_https_client).to receive(:request).with({
        "Content-Type" => "application/json",
        "X-Api-Key" => fake_x_api_key
      }).and_return(fake_response)
    end

    it 'should return the https response' do
      expect(subject).to eq(fake_response)
    end
  end

end
