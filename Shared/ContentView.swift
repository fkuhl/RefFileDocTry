//
//  ContentView.swift
//  Shared
//
//  Created by Frederick Kuhl on 7/14/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: RefFileDocTryDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(RefFileDocTryDocument()))
    }
}
