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
    @State private var path = [Person]()

    @State private var searchText = ""
    
    
    var body: some View {
        NavigationStack(path: $path) {
            PeopleView(searchString: searchText)
                .navigationTitle("FaceFacts")
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(person: person)
                }
                .toolbar {
                    Button("Add Person", systemImage: "plus", action: addPerson)
                }
                .searchable(text: $searchText)
        }
    }
    
    func addPerson() {
        let person = Person(name: "", emailAddress: "", details: "")
        modelContext.insert(person)
        path.append(person)
    }

}

#Preview {
    ContentView()
}
