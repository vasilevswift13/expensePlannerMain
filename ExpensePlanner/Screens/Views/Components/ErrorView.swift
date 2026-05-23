//
//  ErrorView.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 30.04.2026.
//

import SwiftUI

struct ErrorView: View {

    let title: String

    init(title: String = "Error. Please try again later") {
        self.title = title
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.icloud.fill")
                .font(.system(size: 200))
                .foregroundStyle(Color.yellow)
            Text(title)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorView()
}
