//
//  Main.swift
//  RealmFileLockTest
//
//  Created by Gong Zhang on 2024/3/27.
//

import SwiftUI
import RealmSwift

@main
struct Main: SwiftUI.App {
    init() {
        let dir = prepareAppGroupDirectory("group.io.gongzhang.RealmFileLockTest")
        let fileUrl = dir.appendingPathComponent("example.realm")
        
        // store db file in app group
        Realm.Configuration.defaultConfiguration.fileURL = fileUrl
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
    }
}

struct ContentView: View {
    @State private var date = Date()
    
    // FIXME: 💥 this causes 100% crash on visionOS
    @ObservedResults(Person.self) var persons
    
    var body: some View {
        List {
            Section {
                Text("\(date, style: .timer)")
            }
            
            Section {
                ForEach(persons) { person in
                    Text(person.id.uuidString)
                }
                .onDelete(perform: $persons.remove)
            }
        }
        .toolbar {
            Button("Add") {
                $persons.append(Person())
            }
        }
    }
}

class Person: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var age: Int
}

func prepareAppGroupDirectory(_ appGroupId: String) -> URL {
    let fm = FileManager.default
    let containerUrl = fm.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)!
    let dir = containerUrl.appendingPathComponent("Realm", isDirectory: true)
    
    if !fm.fileExists(atPath: dir.path) {
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
    }
    
    return dir
}
