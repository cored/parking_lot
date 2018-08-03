require "dry-struct"
require_relative "./types"

class ParkingLot
  NoAvailableParkingSpot = Class.new(StandardError)
  MAX_SPECIAL_SPOT_SIZE = 50
  PRICES_PER_BRAND = {
    "Dodge" => 50,
    "Jaguar" => 170,
    "Mercedes" => 100,
    "Audi" => 30,
    "Toyota" => 15,
  }

  def self.parking_spots
    normal_size = ("A".."M").each.with_object({}) do |lot_name, parking_spot|
      parking_spot[lot_name] = {size: 20, assigned: [], price: 0}
    end.merge(("M".."Z").each_with_object({}) do |lot_name, parking_spot|
      parking_spot[lot_name] = {size: MAX_SPECIAL_SPOT_SIZE, assigned: [], price: 0}
    end)
  end

  def self.find_parking_spot(vehicles:)
    new(parking_spots: parking_spots).call(vehicles: Types::Vehicles.for(vehicles))
  end

  def initialize(parking_spots:)
    @parking_spots = parking_spots
  end

  def call(vehicles:)
    vehicles.each do |vehicle|
      assign_vehicle_to_available_spots_for(vehicle)
    end
    assigned_parking_spots
  end

  private

  def assign_vehicle_to_available_spots_for(vehicle)
    available_spot_name = available_parking_spot_for(
      unassigned_parking_spots, vehicle.size
    ).first
    assign_vehicle_to(available_spot_name, vehicle)
  end

  def assign_vehicle_to(spot_name, vehicle)
    parking_spots[spot_name][:assigned] << vehicle.to_h
    parking_spots[spot_name][:price] += PRICES_PER_BRAND[vehicle.brand]
  end

  def unassigned_special_parking_spots
    unassigned_parking_spots.select do |_, spot|
      spot[:size] == MAX_SPECIAL_SPOT_SIZE
    end
  end

  def unassigned_parking_spots
    parking_spots.select do |_, spot|
      spot[:assigned].empty?
    end
  end

  def available_parking_spot_for(spots, vehicle_size)
    spots.find do |name, spot|
      spot[:size] >= vehicle_size
    end
  end

  def assigned_parking_spots
    parking_spots.reject do |name, spot|
      spot[:assigned].empty?
    end
  end

  attr_reader :parking_spots
end

