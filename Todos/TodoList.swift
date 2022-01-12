//
//  TodoList.swift
//  Todos
//
//  Created by Ziyi Lu on 2021/4/8.
//

import SwiftUI
import CoreData

struct TodoList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        // MARK: Sort Function
        // TOFIX: seems problems here
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TodoItem.finished, ascending: true),
            NSSortDescriptor(keyPath: \TodoItem.rank, ascending: false),
            NSSortDescriptor(keyPath: \TodoItem.title, ascending: true)
        ],
        animation: .default)
    private var todoItems: FetchedResults<TodoItem>
    
    private var viewModel: ViewModel = ViewModel()
    
    @State var showSheet: Bool = false
    
    @State var alertMessage: String = "None"
    
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(todoItems) { todoItem in
                    TodoRow(todoItem: todoItem, onRankChange: updateTodoRank,
                        onFinishTodo: updateTodoFinish)
                }
                .onDelete(perform: deleteTodoItem)
            }
            .onAppear{
                UITableView.appearance().separatorStyle = .none
            }
            .sheet(isPresented: $showSheet) {
                AddTodo {
                    title, from, to, rank, color in
                    viewModel.addTodoItem(viewContext: viewContext, title: title, from: from, to: to, rank: rank, color: color)
                    self.showSheet = false
                }
            }
            .alert(isPresented: $showAlert) {
                        Alert(title: Text("Important message"), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
                    }
            .navigationBarTitle(Text("Todos"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    self.showSheet.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                )
            )
        }
    }
    
    private func updateTodoRank(todoItem: TodoItem, change: Int16) {
        todoItem.rank += change
        viewModel.saveContext(viewContext: viewContext)
    }
    
    private func updateTodoFinish(todoItem: TodoItem) {
        todoItem.finished.toggle()
        viewModel.saveContext(viewContext: viewContext)
    }
    
    private func deleteTodoItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { todoItems[$0] }.forEach(viewContext.delete)

            viewModel.saveContext(viewContext: viewContext)
        }
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
