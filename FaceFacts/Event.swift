//
//  Event.swift
//  FaceFacts
//
//  Created by John Chavez on 3/31/24.
//

import Foundation
import SwiftData

@Model
class Event {
    var name: String = ""
    var location: String = ""
    var people: [Person]? = [Person]()
    
    
    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}
