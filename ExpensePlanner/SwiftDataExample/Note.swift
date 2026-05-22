//
//  Note.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 05.05.2026.
//

import SwiftData

@Model final class Note {
    var title: String
    var text: String
    var isOver = false

    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}
