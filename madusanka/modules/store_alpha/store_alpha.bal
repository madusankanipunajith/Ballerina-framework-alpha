public type nipFunc function (string x) returns anydata|error;
public type MethRecord record {|
    string name;
    int id;
    nipFunc cf;
|}[];

public MethRecord method_array = [];