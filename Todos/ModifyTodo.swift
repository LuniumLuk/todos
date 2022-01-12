
//
//  ModifyTodo.swift
//  Todos
//
//  Created by Ziyi Lu on 2021/4/8.
//

import SwiftUI

struct ModifyTodo: View {
    static let DefaultTitle = "An Untitled Event"
    
    @State var title: String = ""
    @State var from: Date = Date()
    // @State var to: Date = Date(timeIntervalSinceNow: 3600)
    @State var rank: Int16 = 0
    @State var color: Int = 0
    @State var hours: Int = 1
    @State var minutes: Int = 0
    
    let onSubmit: (String, Date, Date, Int16, Int16) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Title", text: $title)
                    }
                    Section(header: Text("Duration")) {
                        DatePicker("From", selection: $from, displayedComponents: [.date, .hourAndMinute])
                        GeometryReader { geometry in
                            HStack {
                                Picker(selection: $hours, label: Text("Hours")) {
                                    ForEach(0..<24) { index in
                                        HStack {
                                            Text("\(index) h")
                                        }
                                        .tag(index)
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(width: geometry.size.width * 0.5)
                                .clipped()
                                .pickerStyle(WheelPickerStyle())
                                Spacer()
                                Picker(selection: $minutes, label: Text("Minutes")) {
                                    ForEach(0..<12) { index in
                                        HStack {
                                            Text("\(index * 5) m")
                                        }
                                        .tag(index)
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(width: geometry.size.width * 0.5)
                                .clipped()
                                .pickerStyle(WheelPickerStyle())
                            }
                            .frame(height: 100.0)
                        }
                        .frame(height: 100.0)
                    }
                    Section(header: Text("Rank")) {
                        Stepper("Todo rank: \(rank)", onIncrement: {
                                        rank += 1
                                    }, onDecrement: {
                                        rank -= 1
                                    })
                    }
                    Section(header: Text("Tag")) {
                        Picker(selection: $color, label: Text("Tag Color")) {
                            ForEach(0..<TagColors.tagColors.count) { index in
                                HStack {
                                    Text(TagColors.tagColors[index].tag)
                                    Spacer()
                                    Circle()
                                        .fill(TagColors.tagColors[index].color)
                                        .frame(width: 20.0, height: 20.0)
                                }
                                .tag(index)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 100.0)
                        .pickerStyle(InlinePickerStyle())
                    }
                    Section() {
                        Button(action: submitFormAction) {
                          Text("Add Todo Item")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        }
                    }
                    
                }

                
            }
            .navigationBarTitle("Add Todo")
        }
        
    }
    
    private func submitFormAction() {
        onSubmit(
            title.isEmpty ? AddTodo.DefaultTitle : title,
            from,
            from.addingTimeInterval(Double(60 * minutes + 3600 * hours)),
            rank, Int16(color)
        )
    }
}

struct ModyfyTodo_Previews: PreviewProvider {
    static var previews: some View {
        ModifyTodo(onSubmit: { title, from, to, rank, color in
            print("Receive Call")
        })
    }
}
