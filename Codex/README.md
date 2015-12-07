# Codex Framework

The Codex framework provides a mechanism for encoding and decoding subclasses of `CDXModelObject`, based on mappings defined in a Core Data model. Note that `CDXModelObject` is a subclass of `NSObject`, rather than `NSManagedObject` (which is currently unsupported), so dependencies on Core Data classes are limited.

## Features

* Translates between property names and external keypaths (if provided in model).
* Transformation of values between property types and external types (if configured in model).
* Transformation of property values between nil and NSNull external representation.
* Recusively constructs graphs of nested objects during decoding, and graphs of corresponding property list serialization objects (i.e., instances of `NSDictionary`, `NSArray`, etc.) during encoding.

## Limitations

* Currently only supports `NSArray` collection type when modeling to-many relationships.
* No current support for `NSManagedObject`.
* Doesn't currently provide an `NSPersistenStore` subclass.


## Usage

### Decoding

* +modelObjectWithDictionary:entity:

* +modelObjectsWithDictionaries:entity:  <!-- TODO -->

### Encoding

* -dictionaryRepresentation


