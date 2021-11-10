import ballerina/random;

type nipFunc function (string x) returns anydata|error;

// MethRecord is a record array
public type MethRecord record {|
    string name;
    int id;
    nipFunc cf;
|}[];

public MethRecord method_array = [];


# Description about method class
public class method{
    
    private string name;
    private int id;
    private int number;
    private nipFunc cf;

    public function init(string method_name, function x) returns error?{

        // if same function is added, return error value saying same method name is added...
        foreach var item in method_array {
            if (item.name === method_name){
                return error("same request method name cannot be applied...");
            }
        }

        self.cf = <nipFunc> x.clone();
        self.name = method_name;
        self.id = <int> random:createDecimal();

        method_array.push({name: self.name, id: self.id, cf: self.cf});
    }

    public function getFunction() returns function {
        return self.cf;
    }

    
}




// function get(function (string, int) returns int func) returns error?{
    
// }










