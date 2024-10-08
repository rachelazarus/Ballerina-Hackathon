import ballerina/grpc;
import ballerina/log;

// Define the listener on port 9090
listener grpc:Listener ep = new (9090);

// Proto descriptor for the RideService (generated from your .proto file)
@grpc:Descriptor { value: RIDE_SERVICE_DESC }
service "RideService" on ep {

    // Implementing the remote function ScheduleRide
    remote function ScheduleRide(RideRequest value) returns VehicleResponse|error {
        // Log the request for debugging
        log:printInfo("Received request to schedule a ride");

        // Extracting request details
        string departure = value.departure;
        string destination = value.destination;
        int passengers = value.passengers;

        log:printInfo("Departure: " + departure + ", Destination: " + destination + ", Passengers: " + passengers.toString());

        // Sample logic for selecting available vehicles (hardcoded data for now)
        VehicleResponse response = {
            vehicles: [
                { driver: "Ndine Hamukoto", car: "Toyota Corolla", seats: 4 },
                { driver: "Jane Smith", car: "Honda Civic", seats: 4 },
                { driver: "Michael Brown", car: "Ford Focus", seats: 2 },
                { driver: "Sam Wilson", car: "Nissan Micra", seats: 4 }
            ]
        };

        // Return response back to the client
        return response; // Ensure that the response is returned here
    }
}
