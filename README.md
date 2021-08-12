# Doc-Based SwiftUI App with Reference Doc Type

SwiftUI 2 offers a “document-based” app template. This is a simple example of such an app.
It uses a reference type for its document, subclassing `ReferenceFileDocument`, rather than the default `FileDocument`. If the document undergoes complicated changes, reference semantics make more sense than value semantics. It’s also clearer with a `ReferenceFileDocument` how to signal the framework that the document needs to be saved.
See [*Building a Document-Based App with SwiftUI*](https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui)  for important information about setting up the project, particularly UTTypes and UTIs.

## Your document
Your document type must define an associated value type, Snapshot, that encapsulates your document’s state to be saved.
```
func snapshot(contentType: UTType) throws -> Snapshot {
    //return copy of doc state as Snapshot.
}
```

Your document also implements this method, which takes a previously created Snapshot, encodes it to taste, and writes it:
```
func fileWrapper(snapshot: Snapshot, configuration: WriteConfiguration) throws -> FileWrapper {
    let data = ... some encoding, e.g., JSON
    let fileWrapper = FileWrapper(regularFileWithContents: data)
    return fileWrapper
}
```

Each of your document’s mutators should call `undoManager?.registerUndo()`to signal that the document’s state has changed in a way that requires it to be saved. Defining mutators in pairs of inverses makes it easy to register undo / redo pairs. See, for example, `append()`and `removeLast()` on `RefFileTryDocument`. On macOS (not Mac Catalyst) your app will have undo and redo menu items added automatically.

## Access to document and undoManager
Your Views will need access to your document and its undoManager. Define your top-level Scene according to the template, and your top-level `ContentView` will have access to the document as an `@ObservedObject`. The document is available to Views in ContentView’s View hierarchy as an `@EnvironmentObject`.  Note that the hierarchy is interrupted by a NavigationView, requiring you to pass it along explicitly:
```
struct MainView: View {
    @EnvironmentObject *var* document: MyDocument
    var body: *some* View {
        NavigationView {
                //stuff
        }
        .environmentObject(document)
    }
}
```
And similarly when you present a sheet.
Your document’s undoManager is also available in the environment:
`@Environment(\.undoManager) var undoManager`

