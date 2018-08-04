require "spec_helper"

describe ParkingLot do
  describe ".find_parking_spot" do
    context "when looking for an spot for a vehicle" do
      it "returns the first parking spot in which a vehicle can park if any" do
        expect(
          ParkingLot.find_parking_spot(vehicles: [{brand: "Dodge", size: 15}])
        ).to match(
          {
            2 => {
              size: 20,
              price: 50,
              assigned: [{brand: "Dodge", size: 15}]
            },
          }
        )
      end

      it "returns the parking spots for more than one vehicle" do
        vehicles = [
          {brand: "Dodge", size: 15},
          {brand: "Jaguar", size: 45},
        ]

        expect(
          ParkingLot.find_parking_spot(vehicles: vehicles)
        ).to eql({
          2 => {size: 20, price: 50, assigned: [{brand: "Dodge", size: 15}]},
          5 => {size: 50, price: 170, assigned: [{brand: "Jaguar", size: 45}]},
        })
      end

      context "when special spots are available" do
        xit "assigns cars to an special spot depending on the profit" do
          vehicles = [
            {brand: "Dodge", size: 15},
            {brand: "Mercedes", size: 10},
            {brand: "Jaguar", size: 45},
            {brand: "Audi", size: 20},
          ]

          expect(
            ParkingLot.find_parking_spot(vehicles: vehicles)
          ).to eql(
            {
              "M" => {
                size: 50,
                price: 180,
                assigned: [
                  {brand: "Dodge", size: 15},
                  {brand: "Mercedes", size: 10},
                  {brand: "Audi", size: 20},
                ]
              },
              "A" => {
                size: 20,
                price: 0,
                assigned: [{brand: "Audi", size: 20}],
              }
            }
          )
        end
      end
    end
  end
end
