import ballerina/random;
import madusanka.store;

# Description about method class
class method{
    
    private string name;
    private int id;
    private int number;
    private store:nipFunc cf;

    public function init(string method_name, function x) returns error?{

        // if same function is added, return error value saying same method name is added...
        foreach var item in store:method_array {
            if (item.name === method_name){
                return error("same request method name cannot be applied...");
            }
        }

        self.cf = <store:nipFunc> x.clone();
        self.name = method_name;
        self.id = <int> random:createDecimal();

        store:method_array.push({name: self.name, id: self.id, cf: self.cf});
    }

    public function getFunction() returns function {
        return self.cf;
    }

    
}


# Description
#
# + method - User Define Method Name 
# + x - User Define Function
# + return - Return Value Is error otherwise nothing is retured  
public function myFunction(string method, function (store:InputFunc) returns any|error x) returns error?{

    if (store:methodMapper[method] is null) {
     
        store:methodMapper[method] =  x.clone();     
    
    }else{
         return error("same request method name cannot be applied...");
    }
   
}




// function get(function (string, int) returns int func) returns error?{
    
// }










