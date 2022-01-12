//
//  TodosApp.swift
//  Todos
//
//  Created by Ziyi Lu on 2021/4/8.
//

import SwiftUI

@main
struct TodosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TodoList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
