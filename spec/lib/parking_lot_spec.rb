require "spec_helper"

class ParkingLot
  NoAvailableParkingSpot = Class.new(StandardError)

  def self.parking_spots
    ("A".."Z").each.with_object({}) do |lot_name, parking_spot|
      parking_spot[lot_name] = {size: 20, assigned: nil}
    end
  end

  def self.find_parking_spot(vehicles:)
    new(parking_spots: parking_spots).call(vehicles: vehicles)
  end

  def initialize(parking_spots:)
    @parking_spots = parking_spots
  end

  def call(vehicles:)
    assign_vehicles_to_available_spots_for(vehicles)
    assigned_parking_spots
  end

  private

  def assign_vehicles_to_available_spots_for(vehicles)
    vehicles.map do |vehicle|
      available_spot = available_parking_spot_for(unassigned_parking_spots, vehicle)
      parking_spots[available_spot.first][:assigned] = vehicle
    end
  end

  def unassigned_parking_spots
    parking_spots.select do |name, spot|
      spot[:assigned].nil?
    end
  end

  def available_parking_spot_for(spots, vehicle)
    spots.find do |name, spot|
      spot[:size] >= vehicle[:size]
    end
  end

  def assigned_parking_spots
    parking_spots.select do |name, spot|
      spot[:assigned]
    end
  end

  attr_reader :parking_spots
end

describe ParkingLot do
  describe ".find_parking_spot" do
    context "when looking for an spot for a vehicle" do
      # it "returns no parking spot available error for vehicle without info" do
      #   expect{
      #     ParkingLot.find_parking_spot(vehicles: [{}])
      #   }.to raise_error(described_class::NoAvailableParkingSpot)
      # end

      it "returns the first parking spot in which a vehicle can park if any" do
        expect(
          ParkingLot.find_parking_spot(vehicles: [{brand: "Dodge", size: 15, price: 180}])
        ).to eql({"A" => {size: 20, assigned: {brand: "Dodge", size: 15, price: 180}}})
      end

      it "returns the parking spots for more than one vehicle" do
        vehicles =[
          {brand: "Dodge", size: 15, price: 180},
          {brand: "Mercedes", size: 10, price: 50},
          {brand: "Toyota", size: 20, price: 50},
        ]

        expect(
          ParkingLot.find_parking_spot(vehicles: vehicles)
        ).to eql({
          "A" => {size: 20, assigned: {brand: "Dodge", size: 15, price: 180}},
          "B"=> {:size=>20, assigned: {:brand=>"Mercedes", :size=>10, :price=>50}},
          "C"=> {:size=>20, assigned: {:brand=>"Toyota", :size=>20, :price=>50}}
        })
      end
    end
  end
end
