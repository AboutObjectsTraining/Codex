# Codex Example App --- English Literature

Objective-C app that demonstrates use of the Codex framework for data marshaling.


## Features

* **Authors.xcdatamodeld** is a Core Data model that define bindings of JSON or plist keys and values to attributes and relationships expressed in two model object classes: `ELTAuthor`, and `ELTBook`.

* `ELTDataSource` and `ELTObjectStore` classes help provide clean separation of responsibilities. Note that instances used by the app are instantiated in the storyboard file (Main.storyboard), and connected to the table view and table view controller via IBOutlets. The instances are represented by icons in the dock above the **English Literature** scene.