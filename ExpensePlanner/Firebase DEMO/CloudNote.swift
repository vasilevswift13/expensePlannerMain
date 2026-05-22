//
//  CloudNote.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 07.05.2026.
//

import FirebaseFirestore

struct CloudNote: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var text: String
}
