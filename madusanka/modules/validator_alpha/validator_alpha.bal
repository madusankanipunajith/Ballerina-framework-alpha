import ballerina/io;
import ballerina/lang.value;

type JsonRecord record {|
    int id?;
    string method?;
    string result?;
    json|anydata[] params?;
    string jsonrpc;
    json err?;
|};

public type Response record {|
    int id;
    anydata result;
    string jsonrpc;
|};

public type Error record {|
    int? id;
    json err;
    string jsonrpc;
|};

public type Request record {
    int id;
    string method;
    json|anydata[] params;
    string jsonrpc;
};

public type Notification record {
    string method;
    json|anydata[] params;
    string jsonrpc;
};


public type JsonRPCTypes Request|Response|Error|Notification;

public function main() returns error?{
    
    string str = "{\"jsonrpc\":\"2.0\",\"method\":\"display\",\"params\":{\"number\":89, \"street\":\"main street\", \"town\":\"Colombo\"},\"id\":10}";
    string str2 = "{\"id\":10,\"result\":\"this is the result came from server\",\"jsonrpc\":\"2.0\"}";
    string str3 = "{\"jsonrpc\":\"2.0\",\"method\":\"display\",\"params\":{\"number\":89, \"street\":\"main street\", \"town\":\"Colombo\"}, \"s\":\"10\"}";
    string str4 = "{\"jsonrpc\":\"2.0\",\"method\":\"display\",\"params\":{\"number\":89, \"street\":\"main street\", \"town\":\"Colombo\"}}";
    string str5 = "{\"jsonrpc\": \"2.0\", \"error\": {\"code\": -32601, \"message\": \"Method not found\"}, \"id\":23}";

    JsonRPCTypes|error result = messageValidator(str5);
    io:println(result.ensureType());
    io:println(typeof result);
}

// 0 -> notification
// 1 -> request message
// 2 -> response message
// 3 -> invalid message

public function messageValidator(string jsonString) returns JsonRPCTypes|error{
    //io:println("This is json rpc validator...");

    // io:StringReader sr = new(jsonString, encoding = "UTF-8");
    // json message =  check sr.readJson();

    json message = check value:fromJsonString(jsonString);
    
    JsonRecord|error jmessage = message.cloneWithType();
     

    //io:println(sr);

    

    if jmessage is error{
        //return error("something went wrong in message conversion");
        json|error? errId = message.id;
        int? eid; 

        if errId is json{
            eid = <int?> errId;
        }else{
            eid = null;
        }

        Error err = {
            id:  eid,
            err: {code:"-32600", message: "something went wrong in message conversion or Invalid request"},
            jsonrpc: "2.0"
        };

        return err;
    }
    else{
        if jmessage?.id === () && !(jmessage?.method is null) && !(jmessage?.params is null){
            
            Notification r = {
                method: <string> jmessage?.method,
                params: jmessage?.params,
                jsonrpc: "2.0"
            };

            return r;
        }

        if jmessage?.method is null && jmessage?.params is null && jmessage?.err is null && !(jmessage?.id === ()){
            Response r ={
                id: <int> jmessage?.id,
                result: <string> jmessage?.result,
                jsonrpc: "2.0"
            };

            return r;
        }

        if !(jmessage?.err is null) {
            Error r ={
                id: jmessage?.id is null ? null : <int> jmessage?.id,
                err: jmessage?.err,
                jsonrpc: "2.0"
            };

            return r;
        }

        if jmessage?.id !== () && !(jmessage?.method is null) && !(jmessage?.params is null){
            Request r ={
                id: <int> jmessage?.id,
                params: jmessage?.params,
                method: <string> jmessage?.method,
                jsonrpc: "2.0"
            };

            return r;
        }

        //return error("cannot find a json rpc message type");
        Error err={
            id: jmessage?.id is null ? null : <int> jmessage?.id,
            err: {code:"-32600", message:"cannot find a json rpc message type (Invalid JSON object was recieved by the server)"},
            jsonrpc: "2.0"
        };

        return err;
    }
}