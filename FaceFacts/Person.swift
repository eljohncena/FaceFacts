//
//  Person.swift
//  FaceFacts
//
//  Created by John Chavez on 3/31/24.
//

import Foundation
import SwiftData

@Model
class Person {
    
    var name: String = ""
    var emailAddress: String = ""
    var details: String = ""
    var metAt: Event?
    @Attribute(.externalStorage) var photo: Data?
    
    init(name: String, emailAddress: String, details: String, metAt: Event?) {
        self.name = name
        self.emailAddress = emailAddress
        self.details = details
        self.metAt = metAt
    }
}
