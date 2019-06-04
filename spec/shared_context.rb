RSpec.shared_context "diaperbank routes", shared_context: :metadata do
  def diaperbank_routes
    DiaperBankClient::Routes.instance
  end
end

RSpec.configure do |config|
  config.include_context "diaperbank routes", include_shared: true
end
