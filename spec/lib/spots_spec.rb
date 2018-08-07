require "spec_helper"

describe Spots do
  subject(:spots) { described_class }

  describe ".assign" do
    context "when passing nil vehicles" do
      let(:vehicles) { [nil] }

      it "does not raise error" do
        expect(spots.assign(vehicles)).not_to be_nil
      end
    end
  end
end
