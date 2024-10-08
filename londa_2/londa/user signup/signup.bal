import ballerina/http;

// Table to store registered users
table<RegisterUser> key(email) userTable = table[];

// Struct for RegisterUser
type RegisterUser record {
    string userId;
    string firstname;
    string lastname;
    readonly string email;
    string phoneNumber;
    string password;
    string confirmPassword;
};

// Struct for LoginUser
type LoginUser record {
    string email;
    string password;
};

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://127.0.0.1:5500"],
        allowCredentials: false,
        allowHeaders: ["CORELATION_ID"],
        exposeHeaders: ["X-CUSTOM-HEADER"],
        maxAge: 84900
    }
}
  
service /londa on new http:Listener(9090) {

    @http:ResourceConfig {
        cors: {
            allowOrigins: ["http://127.0.0.1:5500"],
            allowCredentials: true,
            allowHeaders: ["X-Content-Type-Options", "X-PINGOTHER"]
        }
    }

    // Register a new user
    resource function post registers(RegisterUser user, http:Caller caller, http:Request req) returns error? {
        if userTable.hasKey(user.email) {
            // If user already exists, return an error response
            check caller->respond({"status": "error", "message": "This user already exists!"});
            return;
        }

        // Check if passwords match
        if (user.password != user.confirmPassword) {
            check caller->respond({"status": "error", "message": "Passwords do not match!"});
            return;
        }

        // Add user to the in-memory table
        userTable.add(user);
        check caller->respond({"status": "success", "message": "User registered successfully"});
    }
   
    // Login a user
    resource function get login(LoginUser loginUser, http:Caller caller, http:Request req) returns error? {

        foreach var login in userTable {
            if (loginUser.email == login.email && loginUser.password == login.password) {
                // Respond with success message
                check caller->respond({
                    "status": "success",
                    "message": "You have successfully logged in"
                });
                check caller->respond();
                return;
            }
        }

        // If credentials do not match
        check caller->respond({"status": "error", "message": "Invalid email or password"});
    }

    resource function get favicon(http:Caller caller) returns error? {
        // Optionally respond with a valid favicon or just leave it empty
        check caller->respond(""); // Respond with no content
    }

    // Retrieve user profile
    resource function get profile(string userEmail, http:Caller caller, http:Request req) returns error? {
        RegisterUser? userDetails = userTable[userEmail];

        if (userDetails is RegisterUser) {
            // Respond with the user profile if found
            check caller->respond(userDetails);
        } else {
            // Respond with an error if the user is not found
            json errorResponse = {
                "status": "error",
                "message": "User does not exist: " + userEmail
            };
            check caller->respond(errorResponse);
        }
    }

    // Update user profile
    resource function put profile(http:Caller caller, http:Request req) returns error? {
        json updatedUserJson = check req.getJsonPayload();
        RegisterUser updatedUser = check updatedUserJson.cloneWithType(RegisterUser);

        if userTable.hasKey(updatedUser.email) {
            foreach var user in userTable {
                if (user.email == updatedUser.email) {
                    // Update user profile fields
                    user.firstname = updatedUser.firstname;
                    user.lastname = updatedUser.lastname;
                    user.phoneNumber = updatedUser.phoneNumber;

                    check caller->respond({
                        "status": "success",
                        "message": "Profile updated successfully"
                    });
                    return;
                }
            }
        } else {
            check caller->respond({"status": "error", "message": "User not found"});
        }
    }

}
