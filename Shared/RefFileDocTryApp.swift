//
//  RefFileDocTryApp.swift
//  Shared
//
//  Created by Frederick Kuhl on 7/14/21.
//

import SwiftUI

@main
struct RefFileDocTryApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: RefFileDocTryDocument.init) { file in
            ContentView(document: file.document)
        }
    }
}
