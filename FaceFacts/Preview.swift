//
//  Preview.swift
//  FaceFacts
//
//  Created by John Chavez on 3/31/24.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let event: Event
    let person: Person
    var isDrawerOpen: Bool = false
    
    
    init(isDrawerOpen: Bool ) throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Person.self, configurations: config)
        
        event = Event(name: "Moonshine", location: "Gaslamp")
        person = Person(name: "John Appleseed", emailAddress: "Johnappleseed@test.com", details: "", metAt: event)
        
        self.isDrawerOpen = isDrawerOpen
        container.mainContext.insert(person)
    }
}
