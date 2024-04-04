//
//  EditPersonView.swift
//  FaceFacts
//
//  Created by John Chavez on 3/31/24.
//

import PhotosUI
import SwiftData
import SwiftUI

struct EditPersonView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var person: Person
    @Bindable var newEvent: Event = Event(name: "", location: "")
    @Binding var navigationPath: NavigationPath
    @State private var selectedItem: PhotosPickerItem?
    @State private var newEventField: Bool = false
    @State private var edit: Bool = false
    
    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)]
    ) var events: [Event]
    
    var body: some View {
        
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
                            .tag(Optional<Event>.none)
                        if events.isEmpty == false {
                            Divider()
                            
                            ForEach(events) { event in
                                Text(event.name)
                                    .tag(Optional(event) ?? newEvent)
                            }
                        }
                    }
                }
                else {
                    TextField("Name", text: $newEvent.name)
                    TextField("Location", text: $newEvent.location)
                }
                if edit {
                    Button("Add new event", action: {
                        newEventField = true
                    })
                }
            }
            Section("Notes") {
                TextField("Details about this person", text: $person.details, axis: .vertical)
            }
        }
        .disabled(!edit)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !edit {
                    Button("Edit", action: {
                        edit.toggle()
                    })
                } else {
                    Button("Save", action: {
                        edit.toggle()
                        addPerson()
                    })
                }
                
            }
            ToolbarItem(placement: .topBarLeading){
                if edit {
                    Button("Cancel", action: {
                        edit.toggle()
                    })
                }
            }
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(edit)
        .onChange(of: selectedItem, loadPhoto)
            
    }
    
    func cancelEdit() {
        
    }
        
    func addPerson() {
        modelContext.insert(person)
        
        if newEventField {
            let event = Event(name: self.newEvent.name, location: self.newEvent.location)
            person.metAt = event
            modelContext.insert(event)
        }
    }
    
    func loadPhoto(){
        Task { @MainActor in
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer(isDrawerOpen: false)
        
        return EditPersonView(person: previewer.person, newEvent: previewer.event, navigationPath: .constant(NavigationPath()))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
