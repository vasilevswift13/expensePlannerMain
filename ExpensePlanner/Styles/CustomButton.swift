//
//  CustomButton.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    init(title: String, systemImage: String, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
            }
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

#Preview {
    CustomButton(title: "Press me", systemImage: "star") { }
}
