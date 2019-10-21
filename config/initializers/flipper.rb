ActiveSupport.on_load(:active_record) do
  require "flipper/adapters/active_record"

  Flipper.configure do |config|
    config.default do
      adapter =
        if Rails.env.test?
          Flipper::Adapters::Memory.new
        else
          Flipper::Adapters::ActiveRecord.new
        end
      Flipper.new(adapter)
    end
  end
end
