//
//  NewPersonPreview.swift
//  FaceFacts
//
//  Created by John Chavez on 4/1/24.
//

import Foundation
import SwiftData

@MainActor
struct NewPersonPreview {
    let container: ModelContainer
    let event: Event
    let person: Person
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Person.self, configurations: config)
        
        event = Event(name: "", location: "")
        person = Person(name: "", emailAddress: "", details: "")
        
        container.mainContext.insert(person)
    }
}
