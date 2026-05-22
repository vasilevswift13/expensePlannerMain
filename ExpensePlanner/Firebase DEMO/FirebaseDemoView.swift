//
//  FirebaseDemoView.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 07.05.2026.
//

import SwiftUI

struct FirebaseDemoView: View {
    @State var text = ""
    @State var currentNote: CloudNote?
    private let service = CloudNotesService()
    
    var body: some View { // computed property
        VStack {
            HStack {
                Button("Send") {
                    Task {
                        try? await service.addNote(title: "Initial note", text: "Wow, it works")
                        print("Note sent")
                    }
                }
                .padding(.leading, 20)
                Spacer()
                Text(text)
                Spacer()
                Button("Fetch") {
                    Task {
                        let notes = try? await service.fetchNotes()
                        print(notes)
                        if let first = notes?.first {
                            text = first.title + ": " + first.text
                            self.currentNote = first
                        } else {
                            text = "No notes found"
                        }
                    }
                }
                .padding(.trailing, 20)
            }
            .cardStyle()
            Button("Delete") {
                guard let currentNote else { return }
                Task {
                    try? await service.deleteNote(currentNote)
                }
            }
        }
    }
}
