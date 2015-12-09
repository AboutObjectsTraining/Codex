# Codex
**Cocoa touch (iOS) framework written in Objective-C**

Version 1.0 *(requires Xcode 7)*

## Overview
A framework and example app that demonstrates the following:

* Leveraging a Core Data model to configure metadata for marshaling data from web services
* Working with Key-Value Coding (KVC) to support encoding and decoding of objects in JSON and/or plist format

## Screenshots

Coming soon.

<!--![](Screenshots/reading-list.png)-->
<!--<span style="width: 36px;">&nbsp;&nbsp;&nbsp;<span>-->
<!--![](Screenshots/swiped-cell.png)-->
<!--<span style="width: 36px;">&nbsp;&nbsp;&nbsp;<span>-->
<!--![](Screenshots/action-sheet.png)-->
<!--<span style="width: 36px;">&nbsp;&nbsp;&nbsp;<span>-->
<!--![](Screenshots/book-detail.png)-->

## Targets

**CodexWorkspace houses the following projects:

* **Codex**

 Objective-C classes that model a reading list containing a list of books and authors, as well as an object store controller that serializes and deserializes object graphs stored in JSON or plist format.

* **CodexExample**

Subclasses and categories on Foundation, UIKit, Core Data, and Codex classes. Storyboard-based. Depends on the *Codex* project.

* **CodexExampleTests**

Unit tests that exercise data marshaling functionality.
 
---

Copyright &copy; 2015, [About Objects, Inc.](http://www.aboutobjects.com) All rights reserved. 