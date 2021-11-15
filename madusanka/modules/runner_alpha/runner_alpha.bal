import ballerina/lang.value;
import madusanka.validator_alpha;
import madusanka.caller_alpha;
import ballerina/io;

public type BatchResponse validator_alpha:JsonRPCTypes[];
BatchResponse batch_res_array = [];

public function executor(string argument) returns validator_alpha:Error|validator_alpha:Response|BatchResponse|error?{
    
    any|error z = trap value:fromJsonString(argument);
    io:println(typeof z);

    if z is any[]{
        //io:println("This is an array");
        if z.length() === 0{
            validator_alpha:Error err ={
                id: null,
                err:{"code": "-32600", "message": "Invalid request"},
                jsonrpc: "2.0"
            };

            return err;
        }else{
            foreach var item in z {
                validator_alpha:JsonRPCTypes? response = check caller_alpha:caller(item.toString());

                if response is validator_alpha:Response || response is validator_alpha:Error{
                    batch_res_array.push(response);
                }
            }

            return batch_res_array;
        }

    }else if z is error {
        //io:println("error is occured...");
        validator_alpha:Error err ={
            id: null,
            err:{"code": "-32700", "message": "Parse error"},
            jsonrpc: "2.0"
        };

        return err;
    }
    else if z is json{
        //io:println("This is a json string");
        // caller function return a panic error if and only if the error is only beign in the user define function
        validator_alpha:JsonRPCTypes? response = check caller_alpha:caller(argument);

        if response is validator_alpha:Error || response is validator_alpha:Response{
            return response;
        }

    }else{
        io:println("Hi");
    }
}