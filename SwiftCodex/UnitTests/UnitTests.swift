//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import XCTest

class UnitTests: XCTestCase
{
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testFoo()
    {
        print("Hello World!")
        print("Bye")
    }
    
    func testKVCExceptionHandling()
    {
        let dict: NSMutableDictionary = ["fooKey": "fooVal"]
        dict["barKey"] = "barVal"
        print("\(dict)")
        
        do {
            try dict.setValue("blah", forKeyPath: "foo.bar")
        }
        catch {
            print("Oops!")
        }
        print("\(dict)")
        
        
//        dict
    }
    
}
