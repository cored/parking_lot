require "spec_helper"

module ParkingLot
  NoAvailableParkingSpot = Class.new(StandardError)

  def self.find_parking_spot(vehicle:)

    raise NoAvailableParkingSpot
  end
end

describe ParkingLot do
  describe ".find_parking_spot" do
    context "when looking for an spot for a vehicle" do
      it "returns no parking spot available error for vehicle without info" do
        expect{
          ParkingLot.find_parking_spot(vehicle: {})
        }.to raise_error(described_class::NoAvailableParkingSpot)
      end

      it "returns the first parking spot in which a vehicle can park if any" do
        expect(
          ParkingLot.find_parking_spot(vehicle: {brand: "Dodge", size: 15, price: 180})
        ).to eql({size: 50, name: "A", assigned: {brand: "Dodge", size: 15, price: 180}})
      end
    end
  end
end
