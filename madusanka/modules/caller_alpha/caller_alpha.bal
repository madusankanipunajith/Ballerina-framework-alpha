import madusanka.validator_alpha;
import madusanka.store_alpha;
import ballerina/io;
import ballerina/lang.value;

public function caller(string message) returns validator_alpha:JsonRPCTypes?|error{

    validator_alpha:JsonRPCTypes|error result = trap validator_alpha:messageValidator(message);

    if result is error{
        validator_alpha:Error err ={
            id: null,
            err: {"code": "-32700", "message": "Parse error"},
            jsonrpc: "2.0" 
        };

        return err;
    
    }else {

        if result is validator_alpha:Request{

            if(store_alpha:methodMapper[result.method] is null){
                
                // method is not found
                validator_alpha:Error err ={
                    id: result.id,
                    err: {code: "-32601", message: "method is not found"},
                    jsonrpc: "2.0"
                };

                return err;
            
            }else{

                function (store_alpha:InputFunc) returns any|error get = store_alpha:methodMapper.get(result.method);
                anydata params = result.params;
                
                store_alpha:InputFunc param;

                if params is anydata[]{
                    json convertToJson = check value:fromJsonString(params.toString());
                    json madu ={
                        arr: convertToJson
                    };

                    param = check madu.cloneWithType();
                   
                }else{
                    param = check params.cloneWithType();     
                }
               
                io:println(typeof params);
                any res = check get(param);
                

                    validator_alpha:Response response = {
                        id: result.id,
                        result: res,
                        jsonrpc: "2.0"
                    };

                    return response;
                }

        }
   
        io:println();
        if result is validator_alpha:Error{
            return result;
        }  

    }
}