module Types
  include Dry::Types.module

  class Vehicles < Dry::Struct
    class Vehicle < Dry::Struct
      attribute :brand, Types::String
      attribute :size, Types::Integer
    end

    def self.for(vehicles)
      new(vehicles: vehicles.map { |vehicle| Vehicle.new(vehicle)} )
    end

    attribute :vehicles, Types::Array.of(Vehicle)

    def each(&block)
      vehicles.each(&block)
    end
  end
end
