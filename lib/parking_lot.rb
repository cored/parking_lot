require "dry-struct"
require_relative "./types"
require_relative "./spots"

class ParkingLot
  NoAvailableParkingSpot = Class.new(StandardError)
  MAX_SPECIAL_SPOT_SIZE = 50

  def self.find_parking_spot(vehicles:)
    new(parking_spots: Spots.init)
      .call(vehicles: Types::Vehicles.for(vehicles))
  end

  def initialize(parking_spots:)
    @parking_spots = parking_spots
  end

  def call(vehicles:)
    vehicles.each do |vehicle|
      parking_spots.assign_vehicle(vehicle)
    end
    parking_spots.to_h
  end

  private

  attr_reader :parking_spots
end

