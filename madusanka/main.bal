import ballerina/io;
import madusanka.method_handler;
import madusanka.validator_alpha;
import madusanka.runner_alpha;
import madusanka.user_alpha;

// user defined record types
type Nip record {|
    int x;
    int y;
|};

type Sip record {|
    int[] arr;
|};

// json rpc messages come from client
string str = "{\"jsonrpc\":\"2.0\",\"method\":\"add\",\"params\":{\"x\":89, \"y\":100},\"id\":10}";
string str2 = "{\"foo\": \"boo\"}";
string str3 = "[{\"jsonrpc\":\"2.0\",\"method\":\"add\",\"params\":{\"x\":89, \"y\":100},\"id\":10}, {\"jsonrpc\":\"2.0\",\"method\":\"subs\",\"params\":{\"x\":89, \"y\":100},\"id\":10}]";
string str4 = "{\"jsonrpc\":\"2.0\",\"method\":\"mult\",\"params\":[10,20,30],\"id\":10}";
string str5 = "{\"jsonrpc\":\"2.0\",\"method\":\"mult\",\"params\":550,\"id\":10}";

public function main() returns error?{

    // user only need to define this after implemeting the methods
    check method_handler:myFunction("add",addFunction);
    check method_handler:myFunction("sub", subFunction);
    check method_handler:myFunction("mult", multFunction);
   
   // This executor function is running dynamically. user doesn,t need to code this. for testing I have run it in main method
   validator_alpha:Error|validator_alpha:Response|runner_alpha:BatchResponse|error? response = runner_alpha:executor(str5);
   io:println(response);
}


// user defined functions .
// user_alpha:InputFunc variable(predefined) is automatically detect the parameter values and stored at there
// user only need to do is fetching those stored values into their own variables
public function addFunction(user_alpha:InputFunc s) returns int|error{
  json nips = <json> s;
  Nip nip = check nips.cloneWithType();
  return nip.x + nip.y;
}

public function subFunction(user_alpha:InputFunc ifs) returns int|error{
    json nips = <json> ifs;
    Nip nip = check nips.cloneWithType();
    return nip.x - nip.y;
}

public function multFunction(user_alpha:InputFunc fis) returns int[]|error{
    json nips = <json> fis;
    Sip nip = check nips.cloneWithType();
    return nip.arr;
}

