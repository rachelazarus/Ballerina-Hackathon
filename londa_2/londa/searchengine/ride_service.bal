import ballerina/http;
import ballerina/io;

// Define a record type for Ride
type Ride record {
    string driverName;
    string car;
    string numberPlate;
    string departure;
    string destination;
    string date;
    string time;
    string driverInfo;
};

// Sample data for available rides
Ride[] availableRides = [
    {driverName: "Ndine Hamukoto", car: "Toyota Corolla", numberPlate: "N 098-123 W", departure: "Katutura", destination: "CBD", date: "2024-10-05", time: "14:00", driverInfo: "Ndine is a computer science student at NUST. She has 5 years of driving experience and is known for her punctuality."},
    {driverName: "Jane Smith", car: "Honda Civic", numberPlate: "N 989-456 S", departure: "Wanaheda", destination: "Olympia", date: "2024-10-06", time: "09:00", driverInfo: "Jane is studying business administration and is passionate about helping others."},
    {driverName: "Michael Brown", car: "Ford Focus", numberPlate: "LMN789", departure: "Khomasdal", destination: "Windhoek West", date: "2024-10-05", time: "15:00", driverInfo: "Michael is a civil engineering student with excellent reviews from passengers."},
    {driverName: "Sam Wilson", car: "Nissan Micra", numberPlate: "N 12 OJ", departure: "Goreangab", destination: "Eros", date: "2024-10-06", time: "11:00", driverInfo: "Sam is a psychology student known for his safe driving and great communication skills."}
];

function search(string searchType, string searchQuery) returns Ride[] {
    io:println("Searching for rides with type: ", searchType, " and query: ", searchQuery);
    Ride[] filteredRides = [];

    foreach Ride ride in availableRides {
        boolean matches = false;

        // Check if the search query matches the departure or destination
        if (searchType == "departure" && ride.departure.includes(searchQuery)) {
            matches = true;
        } else if (searchType == "destination" && ride.destination.includes(searchQuery)) {
            matches = true;
        }

        if (matches) {
            filteredRides.push(ride);
        }
    }

    return filteredRides;
}


// Create an HTTP service
service /rides on new http:Listener(8080) {

    resource function get search(string searchType, string searchQuery) returns Ride[] {
        io:println("Searching for rides with type: ", searchType, " and query: ", searchQuery);
        Ride[] filteredRides = [];

        foreach Ride ride in availableRides {
            boolean matches = false;

            if (searchType == "departure" && ride.departure.includes(searchQuery)) {
                matches = true;
            } else if (searchType == "destination" && ride.destination.includes(searchQuery)) {
                matches = true;
            }

            if (matches) {
                filteredRides.push(ride);
            }
        }

        return filteredRides;
    }
}

// Function to read input from the console
function readInputAndSearch() {
    while (true) {
        io:println("Enter search type (departure/destination) and query (or 'exit' to quit):");
        string? input = io:readln(); // Use readln instead of readLine

        if (input is string && input == "exit") {
            break; // Exit the loop if the user types 'exit'
        } 

        // Check if input is not null
        if (input is string) {
            // Manually extract the search type and query
            int spaceIndex = input.indexOf(" ") ?: 0;
            if (spaceIndex == -1) {
                io:println("Invalid input. Please provide both search type and query.");
                continue;
            }
            string searchType = input.substring(0, spaceIndex);
            string searchQuery = input.substring(spaceIndex + 1);

            // Perform the search using the service method
            Ride[] results = search(searchType, searchQuery);
            
            // Display the results
            if (results.length() > 0) {
                io:println("Found Rides:");
                foreach Ride ride in results {
                    io:println("Driver: ", ride.driverName, ", Car: ", ride.car, ", Departure: ", ride.departure, ", Destination: ", ride.destination);
                }
            } else {
                io:println("No rides found for your query.");
            }
        } else {
            io:println("Input is null or not a string. Please try again.");
        }
    }
}

// Main function to run the service and console input
public function main() {
    io:println("Ride service is running on http://localhost:8080/rides");
    readInputAndSearch(); // Start the console input
}
