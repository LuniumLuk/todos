//
//  TodoRow.swift
//  Todos
//
//  Created by Ziyi Lu on 2021/4/8.
//

import SwiftUI

struct TodoRow: View {
    @ObservedObject var todoItem: TodoItem
    
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM-dd HH:mm"
      return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm"
      return formatter
    }()
    
    let onRankChange: (TodoItem, Int16) -> Void
    
    let onFinishTodo: (TodoItem) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        onFinishTodo(todoItem)
                    }, label: {
                        Circle()
                            .stroke(TagColors.tagColors[Int(todoItem.color)].color, lineWidth: 2.0)
                            
                            .frame(width: 20.0, height: 20.0)
                            .overlay(
                                Bool(todoItem.finished) ?
                                Circle()
                                    .fill(TagColors.tagColors[Int(todoItem.color)].color)
                                    .frame(width: 12.0, height: 12.0)
                                : nil
                            )
                    })
                        .buttonStyle(PlainButtonStyle())
                    
                    todoItem.title.map(Text.init)
                        .font(todoItem.finished ? .title2 : .title)
                        .foregroundColor(todoItem.finished ? .gray : .black)
                }
                todoItem.finished ? nil : HStack {
                    Text(TodoRow.dateFormatter.string(from: todoItem.from ?? Date()) + " - " + (isSameDay(todoItem.from ?? Date(), todoItem.to ?? Date(timeIntervalSinceNow: 3600)) ?
                            TodoRow.timeFormatter.string(from: todoItem.to ?? Date(timeIntervalSinceNow: 3600)) : TodoRow.dateFormatter.string(from: todoItem.to ?? Date(timeIntervalSinceNow: 3600))))
                            .font(.footnote)
                }
            }
            Spacer()
            todoItem.finished ? nil : VStack {
                Button(action: {
                    onRankChange(todoItem, 1)
                }, label: {
                    Image(systemName: "chevron.up")
                        .imageScale(.large)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                })
                    .buttonStyle(PlainButtonStyle())
                Text("\(todoItem.rank)")
                Button(action: {
                    onRankChange(todoItem, -1)
                }, label: {
                    Image(systemName: "chevron.down")
                        .imageScale(.large)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                })
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: Date Compare
    // FIXME: cannot compare base only on date
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
}
