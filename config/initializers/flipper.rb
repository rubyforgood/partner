require "flipper/adapters/active_record"

Flipper.configure do |config|
  config.default do
    # TODO: Figure out in memory adapter when js is enabled.
    Flipper.new(Flipper::Adapters::ActiveRecord.new)
  end
end
