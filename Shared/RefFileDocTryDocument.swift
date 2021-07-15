//
//  RefFileDocTryDocument.swift
//  Shared
//
//  Created by Frederick Kuhl on 7/14/21.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var nameList: UTType {
        UTType(importedAs: "com.example.NameList")
    }
}

class RefFileDocTryDocument: ReferenceFileDocument {
    
    @Published var names: [String]

    static var readableContentTypes: [UTType] { [.nameList] }
    static var writableContentTypes: [UTType] { [.nameList] }
    
    init() {
        NSLog("RFDTD blank init")
        names = [String]()
    }

    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        if data.count == 0 {
            NSLog("RFDTD new file")
            names = [String]()
        }
        names = try JSONDecoder().decode([String].self, from: data)
        NSLog("RFDTD decoded \(names.count) names from \(data.count) bytes")
    }
    
    func snapshot(contentType: UTType) throws -> [String] {
        NSLog("snapshot \(names.count) names")
        return names
    }
    
    func fileWrapper(snapshot: [String], configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(names)
        NSLog("writing \(data.count) bytes")
        return FileWrapper(regularFileWithContents: data)
    }
    
    func append(addition: String) {
        names.append(addition)
    }
}
