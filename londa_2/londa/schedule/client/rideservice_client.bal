import ballerina/io;

// Instantiate the gRPC client with the server URL (assuming the server is running locally on port 9090)
RideServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    // Create a RideRequest with proper values
    RideRequest scheduleRideRequest = {
        departure: "NUST",
        destination: "Downtown",
        date: "2024-10-06",
        time: "10:00 AM",
        passengers: 1
    };

    // Call the ScheduleRide method on the gRPC server and receive the VehicleResponse
    VehicleResponse scheduleRideResponse = check ep->ScheduleRide(scheduleRideRequest);

    // Log the response to the console
    io:println("Available vehicles for the scheduled ride: ", scheduleRideResponse);

    // Optionally, iterate through the vehicles and print each vehicle's details
    foreach var vehicle in scheduleRideResponse.vehicles {
        io:println("Driver: ", vehicle.driver, ", Car: ", vehicle.car, ", Seats Available: ", vehicle.seats);
    }
}

