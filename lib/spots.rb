class Spots
  PRICES_PER_BRAND = {
    "Dodge" => 50,
    "Jaguar" => 170,
    "Mercedes" => 100,
    "Audi" => 30,
    "Toyota" => 15,
  }

  class Spot < Dry::Struct
    Price = Types::Integer.constructor { |brand| PRICES_PER_BRAND[brand] }
    attribute :location, Types::Integer
    attribute :size, Types::Integer
    attribute :price, Price.default(0)
    attribute :assigned, Types::Array.default([])

    def can_fit?(vehicle)
      inclusion_size = ( assigned_vehicles_total_size + vehicle.size)
      (inclusion_size < size && size > vehicle.size)
    end

    def assign(vehicle)
      Spot.new(size: size,
               location: location,
               price: vehicle.brand,
               assigned: assigned + [vehicle])
    end

    def unassigned?
      assigned.empty?
    end

    def to_h
      {
        location => {
          size: size,
          price: price,
          assigned: assigned.map(&:to_h),
        },
      }
    end

    private

    def assigned_vehicles_total_size
      assigned.map(&:size).reduce(0, :+)
    end
  end

  def self.init
    spots = 1.upto(10).map do |location|
      Spot.new(location: location,
               size: location * 10)
    end
    new(spots: spots)
  end

  def self.assign(vehicles)
    spots = init
    vehicles = Types::Vehicles.for(vehicles)
    spots.assign(vehicles)
  end

  def initialize(spots: spots)
    @spots = spots
  end

  def assign(vehicles)
    vehicles.each do |vehicle|
      assign_vehicle(vehicle)
    end

    self
  end

  def to_h
    unassigned_spots.map(&:to_h)
  end

  private

  def unassigned_spots
    spots.reject do |spot|
      spot.unassigned?
    end.uniq
  end

  def assign_vehicle(vehicle)
    spot = available_parking_spot_for(vehicle).assign(vehicle)
    spots << spot
    # spot = spots[location]
    # spots[location].merge!(
    #   size: spot.fetch(:size),
    #   assigned: spot.fetch(:assigned) + [vehicle.to_h],
    #   price: spot.fetch(:price) + PRICES_PER_BRAND[vehicle.brand]
    # )
  end

  def available_parking_spot_for(vehicle)
    spots.find do |spot|
      spot.can_fit?(vehicle)
      # able_to_fit?(spot, vehicle)
    end
  end

  def able_to_fit?(spot, vehicle)
    inclusion_size = (total_assigned_size_for(spot) + vehicle.size)
    spot_size = spot.fetch(:size)
    (inclusion_size < spot_size && spot_size > vehicle.size)
  end

  def total_assigned_size_for(spot)
    spot.fetch(:assigned).reduce(0) do |total, assigned_vehicle|
      total += assigned_vehicle.size
    end
  end

  attr_reader :spots
end
