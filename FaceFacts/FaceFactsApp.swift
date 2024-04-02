//
//  FaceFactsApp.swift
//  FaceFacts
//
//  Created by John Chavez on 3/31/24.
//

import SwiftData
import SwiftUI

@main
struct FaceFactsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(isDrawerOpen: .constant(false))
        }
        .modelContainer(for: Person.self)
        
    }
}
