# Codex
**Cocoa touch (iOS) framework written in Objective-C**

Version 1.0 *(requires Xcode 7)*

## Overview
A framework and example app that demonstrates the following:

* Using Key-Value Coding (KVC) and value transformers (subclasses of `NSValueTransformer`) to support encoding and decoding of model objects from data stored in JSON and/or plist format
* Leveraging a Core Data model to configure metadata needed during data marshaling to specify such things as:
  - Attribute names and types
  - Relationship names and types
  - Inverse relationships
  - External key paths
  - Value transformers


## Screenshots

Coming soon.

<!--![](Screenshots/reading-list.png)-->
<!--<span style="width: 36px;">&nbsp;&nbsp;&nbsp;<span>-->
<!--![](Screenshots/swiped-cell.png)-->
<!--<span style="width: 36px;">&nbsp;&nbsp;&nbsp;<span>-->
<!--![](Screenshots/action-sheet.png)-->
<!--<span style="width: 36px;">&nbsp;&nbsp;&nbsp;<span>-->
<!--![](Screenshots/book-detail.png)-->

## Projects

The Codex workspace includes the following projects:

[Codex](https://github.com/AboutObjectsTraining/Codex/tree/master/Codex)

The Codex framework provides a mechanism for encoding and decoding subclasses of `CDXModelObject`, based on mappings defined in a Core Data model.

[CodexExample](https://github.com/AboutObjectsTraining/Codex/tree/master/CodexExample)

An Objective-C app that demonstrates use of the Codex framework for data marshaling. Storyboard-based. Depends on the [Codex](https://github.com/AboutObjectsTraining/Codex/tree/master/Codex) framework.
 
---

Copyright &copy; 2015, [About Objects, Inc.](http://www.aboutobjects.com) All rights reserved. 