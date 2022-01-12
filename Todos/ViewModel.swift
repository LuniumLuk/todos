//
//  ViewModel.swift
//  Todos
//
//  Created by Ziyi Lu on 2021/5/2.
//

import Foundation
import SwiftUI
import CoreData

class ViewModel: ObservableObject {
    
    init() {}
    
    func addTodoItem(viewContext: NSManagedObjectContext, title: String, from: Date, to: Date, rank: Int16, color: Int16) {
        withAnimation {
            let newTodoItem = TodoItem(context: viewContext)
            
            newTodoItem.title = title
            newTodoItem.from = from
            newTodoItem.to = to
            newTodoItem.rank = rank
            newTodoItem.color = color
            newTodoItem.finished = false
            
            saveContext(viewContext: viewContext)
        }
    }
    
    // save context with error handeling
    func saveContext(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
