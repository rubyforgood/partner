require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "humanize_boolean" do
    context "true boolean" do
      it "returns yes" do
        expect(helper.humanize_boolean(true)).to eq("Yes")
      end
    end

    context "false boolean" do
      it "returns no" do
        expect(helper.humanize_boolean(false)).to eq("No")
      end
    end

    context "nil boolean" do
      it "returns no" do
        expect(helper.humanize_boolean(nil)).to eq("No")
      end
    end
  end
end
