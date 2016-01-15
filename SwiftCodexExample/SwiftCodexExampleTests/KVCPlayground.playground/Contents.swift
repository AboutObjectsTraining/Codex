//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

class Book: NSObject {
    var title: String?

    var favorite: Bool?
    var kvc_favorite: Bool {
        get { return favorite ?? false }
        set { favorite = Optional(newValue) }
    }
    
    override func setNilValueForKey(key: String) {
        if !key.hasPrefix("kvc_") {
            super.setNilValueForKey(key)
        }
    }
    
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        return key.hasPrefix("kvc_") ? nil : super.valueForKey("kvc_" + key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        if !key.hasPrefix("kvc_") {
            super.setValue(value, forKey: "kvc_" + key)
        }
    }
}

var book = Book()

book.valueForKey("favorite")
book.setValue(NSNumber(int: 1), forKey: "favorite")
print(book.valueForKey("favorite"))

book.setValue(nil, forKey: "favorite")
print(book.valueForKey("favorite"))

book.setValue("Foo", forKey: "title")
print(book.valueForKey("title"))
