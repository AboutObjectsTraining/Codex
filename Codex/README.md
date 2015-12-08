# Codex Framework

The Codex framework provides a mechanism for encoding and decoding subclasses of `CDXModelObject`, based on mappings defined in a Core Data model. Note that `CDXModelObject` is a subclass of `NSObject`, rather than `NSManagedObject` (which is currently unsupported), so dependencies on Core Data classes are limited.

## Features

* Allows custom bindings between model object property names and JSON or plist key paths.
  To specify an custom binding, select an attribute or relationship in the Core Data model, and add an entry in the User Info section, setting the key to `externalKeypath`, and the value to the key path for the corresponding object in the JSON or plist data.
* Transformation of values between property types and external types (if configured in model).
  To specify a custom transformation for an attribute in the Core Data model, set it's type to Transformable, and specify the name of the subclass of `NSValueTransformer` that implements the desired transformation.
* Automatic transformation between `nil` object property values and their `NSNull` external representation.
* Recusively constructs graphs of nested objects during decoding, and graphs of corresponding property list serialization objects (i.e., instances of `NSDictionary`, `NSArray`, etc.) during encoding. Automatically sets back-pointers for inverse relationships.

## Limitations

* Currently only supports `NSArray` collection type for modeling to-many relationships.
* Doesn't currently support `NSManagedObject`.
* Doesn't currently provide an `NSPersistentStore` subclass.


## Usage

### Decoding

* +modelObjectWithDictionary:entity:

* +modelObjectsWithDictionaries:entity:  <!-- TODO -->

### Encoding

* -dictionaryRepresentation


