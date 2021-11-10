import ballerina/io;
import madusanka.method_handler;
import madusanka.validator_alpha;
import madusanka.caller_alpha;
import madusanka.filter_alpha;

type ASP record {
    int x;
    int y;
};

string str = "{\"jsonrpc\":\"2.0\",\"method\":\"add\",\"params\":{\"x\":89, \"y\":100},\"id\":10}";

public function main() returns error?{

    method_handler:method method_1 =  check new("add", addFunction);
    method_handler:method method_2 =  check new("sub", subFunction);


    validator_alpha:JsonRPCTypes?|error response = caller_alpha:caller(str);
    io:println(response);
}



// user defined functions
public function addFunction(string msg) returns int|error{
    
    anydata x = check filter_alpha:paramFilter(msg);
    ASP asp = check x.cloneWithType();
    
    return asp.x + asp.y;
}

public function subFunction(string msg) returns int|error{

   anydata x = check filter_alpha:paramFilter(msg);
   ASP asp = check x.cloneWithType();
    
    return asp.x - asp.y;
}
