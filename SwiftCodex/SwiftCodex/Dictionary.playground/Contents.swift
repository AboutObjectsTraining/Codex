//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let mutableDict: NSMutableDictionary = NSMutableDictionary(dictionary:
    ["fooKey": "fooVal", "barKey": "barVal"])

let immutableDict: NSDictionary = mutableDict.copy() as! NSDictionary

let swiftDict: [String: AnyObject] = immutableDict as! [String: AnyObject]

let swiftDict2: [String: AnyObject] = mutableDict as! [String: AnyObject]

swiftDict2["fooKey"]
swiftDict is [String: AnyObject]
swiftDict2 is [String: AnyObject]
mutableDict is [String: AnyObject]
immutableDict is [String: AnyObject]


let dict = mutableDict.copy() as! [String: AnyObject]
dict.keys

mutableDict.setValue("Wow!", forKeyPath: "foo.bar")

