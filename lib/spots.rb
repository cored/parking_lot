class Spots
  PRICES_PER_BRAND = {
    "Dodge" => 50,
    "Jaguar" => 170,
    "Mercedes" => 100,
    "Audi" => 30,
    "Toyota" => 15,
  }

  def self.init
    spots = 1.upto(10).each.with_object({}) do |location, lot|
      lot.merge!({
        location => {
          size: location * 10,
          price: 0,
          assigned: [],
        }
      })
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
    spots.reject do |name, spot|
      spot.fetch(:assigned).empty?
    end
  end

  private

  def assign_vehicle(vehicle)
    location, _ = available_parking_spot_for(vehicle)
    spot = spots[location]
    spots[location].merge!(
      size: spot.fetch(:size),
      assigned: spot.fetch(:assigned) + [vehicle.to_h],
      price: spot.fetch(:price) + PRICES_PER_BRAND[vehicle.brand]
    )
  end

  def available_parking_spot_for(vehicle)
    spots.find do |name, spot|
      able_to_fit?(spot, vehicle)
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
