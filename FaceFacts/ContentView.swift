//
//  ContentView.swift
//  FaceFacts
//
//  Created by John Chavez on 3/31/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = NavigationPath()
    @State private var sortOrder = [SortDescriptor(\Person.name)]
    @State private var searchText = ""
    @State private var isDrawerOpen: Bool = false
    
    
    var body: some View {
        VStack {
            ZStack {
                VStack {

                    NavigationStack(path: $path) {
                        PeopleView(searchString: searchText, sortOrder: sortOrder)
                            .navigationTitle("FaceFacts")
                            .navigationDestination(for: Person.self) { person in
                                EditPersonView(person: person, navigationPath: $path)
                            }
                            .toolbar {
                                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                                    Picker("Sort", selection: $sortOrder) {
                                        Text("Name (A-Z")
                                            .tag([SortDescriptor(\Person.name)])
                                        Text("Name (Z-A")
                                            .tag([SortDescriptor(\Person.name, order: .reverse)])
                                    }
                                }
                                Button("Add Person", systemImage: "plus", action:{isDrawerOpen.toggle()} )
                            }
                        }
                    .searchable(text: $searchText)
                }
            }
        }
        .sheet(isPresented: $isDrawerOpen) {
            DrawerView(isDrawerVisible: $isDrawerOpen)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer(isDrawerOpen: false)
        
        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
