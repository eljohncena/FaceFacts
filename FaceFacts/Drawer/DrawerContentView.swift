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
    
    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)]
    ) var events: [Event]
    
    var body: some View {
        ZStack {
            NavigationStack {
//                drawerTopView()
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
                        Picker("Met at", selection: $person.metAt) {
                            Text("Unknown event")
                                .tag(Optional<Event>.none)
                            if events.isEmpty == false {
                                Divider()
                                
                                ForEach(events) { event in
                                    Text(event.name)
                                        .tag(Optional(event))
                                }
                            }
                        }
                        Button("Add new event", action: addEvent)
                    }
                    Section("Notes") {
                        TextField("Details about this person", text: $person.details, axis: .vertical)
                    }
                }
                .toolbar {
                    Button("Cancel", action: {
                        currentDrawer.toggle()
                    })
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("New Contact")
            }
        }

    }
    
//    func drawerTopView() -> some View {
//        VStack {
//            HStack {
//                Button("Cancel", action: {
//                    currentDrawer.toggle()
//                })
//                .frame(width: 34, height: 34)
//                Spacer()
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.leading, 10)
////        .padding(.top, 40)
////        .padding(.bottom, 30)
//    }
    
    func addEvent() {
        let event = Event(name: "", location: "")
        modelContext.insert(event)
        
    }
    
    func addPerson() {
        modelContext.insert(person)
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
