require "spec_helper"

describe "db:seed" do
  before { Rails.application.load_tasks }

  it { expect { Rake::Task["db:seed"].invoke }.not_to raise_exception }
end
