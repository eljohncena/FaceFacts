//
//  DrawerView.swift
//  FaceFacts
//
//  Created by John Chavez on 4/1/24.
//

import SwiftUI

struct DrawerView: View {

    private let height = UIScreen.main.bounds.height - 100
    @Binding var isDrawerVisible: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DrawerContentView(person: Person(name: "", emailAddress: "", details: "", metAt: nil ), currentDrawer: $isDrawerVisible)
        }
    }
}


#Preview {
    do {
        let preview = try NewPersonPreview()
        return DrawerView(isDrawerVisible: .constant(true))
            .modelContainer(preview.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

