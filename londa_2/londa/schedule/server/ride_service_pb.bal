import ballerina/grpc;
import ballerina/protobuf;

public const string RIDE_SERVICE_DESC = "0A12726964655F736572766963652E70726F746F2295010A0B5269646552657175657374121C0A09646570617274757265180120012809520964657061727475726512200A0B64657374696E6174696F6E180220012809520B64657374696E6174696F6E12120A046461746518032001280952046461746512120A0474696D65180420012809520474696D65121E0A0A70617373656E67657273180520012805520A70617373656E6765727322490A0756656869636C6512160A06647269766572180120012809520664726976657212100A03636172180220012809520363617212140A0573656174731803200128055205736561747322370A0F56656869636C65526573706F6E736512240A0876656869636C657318012003280B32082E56656869636C65520876656869636C6573323D0A0B5269646553657276696365122E0A0C5363686564756C6552696465120C2E52696465526571756573741A102E56656869636C65526573706F6E7365620670726F746F33";

public isolated client class RideServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, RIDE_SERVICE_DESC);
    }

    isolated remote function ScheduleRide(RideRequest|ContextRideRequest req) returns VehicleResponse|grpc:Error {
        map<string|string[]> headers = {};
        RideRequest message;
        if req is ContextRideRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RideService/ScheduleRide", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <VehicleResponse>result;
    }

    isolated remote function ScheduleRideContext(RideRequest|ContextRideRequest req) returns ContextVehicleResponse|grpc:Error {
        map<string|string[]> headers = {};
        RideRequest message;
        if req is ContextRideRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RideService/ScheduleRide", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <VehicleResponse>result, headers: respHeaders};
    }
}

public isolated client class RideServiceVehicleResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendVehicleResponse(VehicleResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextVehicleResponse(ContextVehicleResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextVehicleResponse record {|
    VehicleResponse content;
    map<string|string[]> headers;
|};

public type ContextRideRequest record {|
    RideRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: RIDE_SERVICE_DESC}
public type Vehicle record {|
    string driver = "";
    string car = "";
    int seats = 0;
|};

@protobuf:Descriptor {value: RIDE_SERVICE_DESC}
public type VehicleResponse record {|
    Vehicle[] vehicles = [];
|};

@protobuf:Descriptor {value: RIDE_SERVICE_DESC}
public type RideRequest record {|
    string departure = "";
    string destination = "";
    string date = "";
    string time = "";
    int passengers = 0;
|};

