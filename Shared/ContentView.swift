//
//  ContentView.swift
//  Shared
//
//  Created by Frederick Kuhl on 7/14/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var document: RefFileDocTryDocument

    var body: some View {
        List {
            ForEach(document.names, id: \.self) { name in
                Text(name)
            }
            AddView(document: document)
        }
        .padding()
        .frame(minWidth: 300, minHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: RefFileDocTryDocument())
    }
}

struct AddView: View {
    @Environment(\.undoManager) var undoManager
    @ObservedObject var document: RefFileDocTryDocument
    @State private var addition = ""
    @StateObject var handler: UndoHandler<RefFileDocTryDocument> = UndoHandler()
    
    var body: some View {
        HStack {
            Button(action: addOne) {
                Image(systemName: "plus").font(.body)
            }
            TextField("Add name", text: $addition)
        }
    }
    
    private func addOne() {
        document.append(addition: addition)
        handler.registerUndo(from: RefFileDocTryDocument(), to: RefFileDocTryDocument())
    }
}

class UndoHandler<Value>: ObservableObject {
    var binding: Binding<Value>?
    weak var undoManger: UndoManager?
    
    func registerUndo(from oldValue: Value, to newValue: Value) {
        undoManger?.registerUndo(withTarget: self) { handler in
            handler.registerUndo(from: newValue, to: oldValue)
            handler.binding?.wrappedValue = oldValue
        }
    }
    
    init() {}
}
