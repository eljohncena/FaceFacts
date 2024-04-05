//
//  DrawerContentView.swift
//  FaceFacts
//
//  Created by John Chavez on 4/1/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct DrawerContentView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var person: Person
    @State private var selectedItem: PhotosPickerItem?
    @Binding var currentDrawer: Bool
    @State private var newEventField: Bool = false
    @State private var newEvent: Event = Event(name: "", location: "")
    
    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)]
    ) var events: [Event]
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section {
                        if let imageData = person.photo, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        PhotosPicker(selection: $selectedItem, matching: .images){
                            Label("Select a photo", systemImage: "person")
                        }
                    }
                    Section {
                        TextField("Name", text: $person.name)
                            .textContentType(.name)
                        TextField("Email address", text: $person.emailAddress)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                    }
                    Section("Where did you meet them?") {
                        if !newEventField{
                            Picker("Met at", selection: $person.metAt) {
                                Text("Select event")
                                    .tag(nil as Event?)
                                if events.isEmpty == false {
                                    Divider()
                                    
                                    ForEach(events) { event in
                                        Text(event.name)
                                            .tag(event as Event?)
                                    }
                                }
                            }
                        }
                        else {
                            TextField("Name", text: $newEvent.name)
                            TextField("Location", text: $newEvent.location)
                        }
                        Button("Add new event", action: {
                            newEventField = true
                        })
                    }
                    Section("Notes") {
                        TextField("Details about this person", text: $person.details, axis: .vertical)
                    }
                }
                .toolbar {
                    
                    ToolbarItem(placement: .topBarLeading){
                        Button("Cancel", action: {
                            currentDrawer.toggle()
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save", action: {
                            addPerson()
                            currentDrawer.toggle()
                        })
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("New Contact")
            }
        }

    }
    
    func addPerson() {
        modelContext.insert(person)
        
        if newEventField {
            let event = Event(name: newEvent.name, location: newEvent.location)
            modelContext.insert(event)
            person.metAt = event
        }
    }
    
}



#Preview {
    do {
        let previewer = try NewPersonPreview()
        
        return DrawerContentView(person: previewer.person, currentDrawer: .constant(true))
            .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
