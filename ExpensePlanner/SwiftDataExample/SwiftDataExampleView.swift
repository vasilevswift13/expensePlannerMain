//
//  SwiftDataExampleView.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 05.05.2026.
//

import SwiftData
import SwiftUI

struct SwiftDataExampleView: View {

    @Environment(\.modelContext) private var modelContext

    @Query private var notes: [Note]

    var body: some View {
        HStack {
            Button("Save") {
                let note = Note(title: "Test", text: "Test info")
                modelContext.insert(note)
                try? modelContext.save()
            }
            .padding(.leading, 20)
            Spacer()
            Button("Clear") {
                try? searchAndDestroy()
            }
            .padding(.trailing, 20)
        }
        List {
            ForEach(notes) { note in
                HStack {
                    Text(note.title + " " + note.text)
                        .foregroundColor(note.isOver ? .gray : .primary)
                    Spacer()
                    Button("Set done") {
                        note.isOver.toggle()
                        try? modelContext.save()
                    }
                }
            }
            .onDelete(perform: deleteNotes)
        }
    }

    private func deleteNotes(at offsets: IndexSet) {
        if let index = offsets.first {
            modelContext.delete(notes[index])
        }
        try? modelContext.save()
    }

    private func searchAndDestroy() throws {
        let predicate = #Predicate<Note> { $0.title == "Test" } // фильтр для поиска объектов в БД
        let descriptor = FetchDescriptor<Note>(predicate: predicate) // обертка предиката, можно добавить сортировку выдачи

        let notes = try modelContext.fetch(descriptor) // поиск в БД по предикату

//        if let note = notes.first {
//            context.delete(note)
//        }

        for note in notes {
            modelContext.delete(note)
        }

        try? modelContext.save()
    }
}

#Preview {
    SwiftDataExampleView()
}

