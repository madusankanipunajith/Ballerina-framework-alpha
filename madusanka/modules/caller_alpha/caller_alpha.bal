import madusanka.validator_alpha;
import madusanka.method_handler;

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

            foreach var item in method_handler:method_array {

                if (item.name === result.method){

                    validator_alpha:Response response = {
                        id: result.id,
                        result: check item.cf(message),
                        jsonrpc: "2.0"
                    };

                    return response;
                }
            }

            // method is not found
            validator_alpha:Error err ={
                id: result.id,
                err: {code: "-32601", message: "method is not found"},
                jsonrpc: "2.0"
            };

            return err;
        }

        if result is validator_alpha:Error{
            return result;
        }    
    }
}