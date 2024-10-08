import ballerina/http;
import ballerina/log;
import ballerina/io;

// Define the HTTP listener
service /suggestions on new http:Listener(9090) {

    // Handle incoming POST requests
    resource function post .(http:Caller caller, http:Request req) returns error? {
        // Parse the request body as JSON
        json requestBody = check req.getJsonPayload();

        // Extract the suggestion
        string suggestion = (check requestBody.suggestion).toString();
        log:printInfo("Received suggestion: " + suggestion);

        // You can process/store the suggestion as needed

        // Return a success response
        json responseJson = { message: "Suggestion received successfully!" };
        // Send response
        check caller->respond(responseJson);
        
        // Return nil to indicate successful completion
        return;  // or return nil;
    }
}

// Main function to prompt for suggestions from the terminal
public function main() {
    io:println("Welcome to Londa Rides Suggestion System!");

    while (true) {
        // Prompt for a suggestion
        io:print("Please enter your suggestion (or type 'exit' to quit): ");
        
        // Read user input
        string choice = io:readln();

        if (choice != "exit") {
            // Log the suggestion to the console
            log:printInfo("User suggestion: " + choice);
            
            // Here, you can send the suggestion to your HTTP service
            // For demonstration, we'll just log it
            log:printInfo("Suggestion submitted: " + choice);
        } else {
            break; // Exit the loop if the user types 'exit'
        }
    }

    io:println("Thank you for using Londa Rides Suggestion System. Goodbye!");
}
