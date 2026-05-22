//
//  CloudNotesService.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 07.05.2026.
//

import FirebaseFirestore
final class CloudNotesService {

    private let db = Firestore.firestore()
    private let collectionName = "notes"

    func fetchNotes() async throws -> [CloudNote] {
        let snapshot = try await db
            .collection(collectionName)
            .order(by: "title")
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: CloudNote.self)
        }
    }

    func addNote(title: String, text: String) async throws {
        let note = CloudNote(title: title, text: text)

        try db
            .collection(collectionName)
            .addDocument(from: note)
    }

    func deleteNote(_ note: CloudNote) async {
        guard let id = note.id else { return }
        try? await db
            .collection(collectionName)
            .document(id)
            .delete()
    }
}
