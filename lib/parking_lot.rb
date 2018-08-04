require "dry-struct"
require_relative "./types"
require_relative "./spots"

module ParkingLot
  NoAvailableParkingSpot = Class.new(StandardError)
  MAX_SPECIAL_SPOT_SIZE = 50

  def self.find_parking_spot(vehicles:)
    Spots.assign(vehicles).to_h
  end
end

